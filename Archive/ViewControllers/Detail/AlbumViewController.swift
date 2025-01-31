//
//  AlbumViewController.swift
//  Archive
//
//  Created by 이수현 on 1/15/25.
//

import UIKit

class AlbumViewController: UIViewController {
    private let musicService = MusicService() // 예시
    private let artist = "IU"
    
    private let albumView = AlbumView()
    private let data = AlbumCurationDummyModel.dummy()
    private var albumData: AlbumInfoReponseDTO?

    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = albumView
    
        setNavigationBar()
        setDataSource()
        setSnapshot()
        setProtocol()
        updateTrackViewHeight()
        
        // 앨범 정보 API
        postMusicAlbum(artist: artist, album: "Love poem")
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
            guard let self = self else {return UICollectionReusableView() }
            let section = self.dataSource?.sectionIdentifier(for: indexPath.section)
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderView.id, for: indexPath)
            // 버튼에 UIAction 추가
            (headerView as? HeaderView)?.detailButton.addAction(UIAction(handler: { [weak self] _ in
                guard let self = self, let section = section else { return }
                self.handleDetailButtonTap(for: section)
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
    
    private func handleDetailButtonTap(for section: Section) {
        let nextVC = DetailViewController(section: section)
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
    func postMusicAlbum(artist: String, album: String) { // musicService의 album 함수의 파라미터로 artist, album이 필요하기 때문에 받아옴
        // musicService의 album 함수 사용
        musicService.album(artist: artist, album: album){ [weak self] result in // 반환값 result의 타입은 Result<AlbumInfoReponseDTO?, NetworkError>
            guard let self = self else { return }
            
            switch result {
            case .success(let response): // 네트워크 연결 성공 시 데이터를 UI에 연결 작업
                guard let data = response else { return }
                albumView.config(data: data, artist: artist, description: "asd")
                
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
