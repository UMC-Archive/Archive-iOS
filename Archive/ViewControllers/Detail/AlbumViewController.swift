//
//  AlbumViewController.swift
//  Archive
//
//  Created by 이수현 on 1/15/25.
//

import UIKit

class AlbumViewController: UIViewController {
    private let musicService = MusicService() // 예시
    private let artist: String
    private let album: String
    
    private let albumView = AlbumView()
    private let data = AlbumCurationDummyModel.dummy()
    private var albumData: AlbumInfoReponseDTO?

    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>?
    
    init(artist: String = "IU", album: String = "Love poem") {
        self.artist = artist
        self.album = album
        
        super.init(nibName: nil, bundle: nil)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = albumView
        setNavigationBar()
        setDataSource()
        setSnapshot()
        setProtocol()
        updateTrackViewHeight()
        
        // 앨범 정보 API
        postAlbumInfo(artist: artist, album: album)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    private func setNavigationBar(){
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        
        // 뒤로 가기
        let popButton = UIBarButtonItem(image: .init(systemName: "chevron.left"), style: .plain, target: self, action: #selector(tapPopButton))
        self.navigationItem.leftBarButtonItem = popButton
        
        // 좋이요
        let heartButton = UIBarButtonItem(image: .addLibrary, style: .done, target: self, action: #selector(tapHeartButton))
        self.navigationItem.rightBarButtonItem = heartButton
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    @objc private func tapPopButton() {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func tapHeartButton() {
        // 좋아요 API 연결
        print("tapHeartButton")
    }
    
    private func updateTrackViewHeight(){
        albumView.trackView.snp.updateConstraints { make in
            make.height.equalTo(180 + data.albumTrack.count * 60)
        }
        
        albumView.layoutIfNeeded()
    }
    
    private func setProtocol() {
        albumView.trackView.trackCollectionView.dataSource = self
        albumView.trackView.trackCollectionView.delegate = self
    }
    
    private func setDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: albumView.collectionView){ collectionView, indexPath, ItemIdentifier in
            switch ItemIdentifier {
            case .AnotherAlbum(let item), .RecommendAlbum(let item):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCell.id, for: indexPath)
                (cell as? BannerCell)?.configAlbum(data: item)
                return cell
            default:
                return UICollectionViewCell()
            }
        }
        
        dataSource?.supplementaryViewProvider = {[weak self] collectionView, kind, indexPath in
            guard let self = self, let section = self.dataSource?.sectionIdentifier(for: indexPath.section), let item = dataSource?.snapshot(for: section) else {return UICollectionReusableView() }
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderView.id, for: indexPath)
            // 버튼에 UIAction 추가
            (headerView as? HeaderView)?.detailButton.addAction(UIAction(handler: { [weak self] _ in
                guard let self = self else { return }
                self.handleDetailButtonTap(for: section, item: item)
            }), for: .touchUpInside)

            switch section {
            case .Banner(let headerTitle):
                (headerView as? HeaderView)?.config(headerTitle: headerTitle)
            default:
                return UICollectionReusableView()
            }
            
            return headerView
        }
        
    }
    
    // 자세히 보기 버튼
    private func handleDetailButtonTap(for section: Section, item: NSDiffableDataSourceSectionSnapshot<Item>) {
        let nextVC = DetailViewController(section: section, item: item)
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    private func setSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        
        let anotherAlbumSection = Section.Banner(.AnotherAlbum) // 이 아티스트의 다른 앨범
        let recommendAlbumSection = Section.Banner(.RecommendAlbum) // 당신을 위한 추천 핼범
        
        snapshot.appendSections([anotherAlbumSection, recommendAlbumSection])
        
        let anotherAlbumItem = data.anotherAlbum.map{Item.AnotherAlbum($0)}
        let recommendAlbumItem = data.recommendAlbum.map{Item.RecommendAlbum($0)}
        
        snapshot.appendItems(anotherAlbumItem, toSection: anotherAlbumSection)
        snapshot.appendItems(recommendAlbumItem, toSection: recommendAlbumSection)
        
        dataSource?.apply(snapshot)
    }
    
    // 앨범 정보 가져오기 API
    func postAlbumInfo(artist: String, album: String) { // musicService의 album 함수의 파라미터로 artist, album이 필요하기 때문에 받아옴
        // musicService의 album 함수 사용
        musicService.album(artist: artist, album: album){ [weak self] result in // 반환값 result의 타입은 Result<AlbumInfoReponseDTO?, NetworkError>
            guard let self = self else { return }
            
            switch result {
            case .success(let response): // 네트워크 연결 성공 시 데이터를 UI에 연결 작업
                guard let data = response else { return }
                albumData = data
                postAlbumCuration(albumId: data.id)
//
//                albumView.config(data: data, artist: artist, description: "asd")
                
            case .failure(let error): // 네트워크 연결 실패 시 얼럿 호출
                // 네트워크 연결 실패 얼럿
                let alert = NetworkAlert.shared.getAlertController(title: error.description) // 얼럿 생성
                self.present(alert, animated: true) // 얼럿 띄우기
                print("실패: \(error.description)")
            }
        }
    }
    
    // 앨범 큐레이션 API
    func postAlbumCuration(albumId: String) {
        musicService.albumCuration(albumId: albumId){ [weak self] result in // 반환값 result의 타입은 Result<String?, NetworkError>
            guard let self = self else { return }
            
            switch result {
            case .success(let response): // 네트워크 연결 성공 시 데이터를 UI에 연결 작업
                guard let response = response, let data = self.albumData else { return }
                albumView.config(data: data, artist: artist, description: response.description)
                
            case .failure(let error): // 네트워크 연결 실패 시 얼럿 호출
                // 네트워크 연결 실패 얼럿
                let alert = NetworkAlert.shared.getAlertController(title: error.description) // 얼럿 생성
                self.present(alert, animated: true) // 얼럿 띄우기
                print("실패: \(error.description)")
            }
        }
    }
}

extension AlbumViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case albumView.trackView.trackCollectionView:
            return data.albumTrack.musicList.count
        default:
            return data.albumTrack.musicList.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("cellForItemAt")
        switch collectionView {
        case albumView.trackView.trackCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VerticalCell.id, for: indexPath) as? VerticalCell else {return UICollectionViewCell()
            }
            cell.config(data: data.albumTrack.musicList[indexPath.row])
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}

extension AlbumViewController: UICollectionViewDelegate { }
