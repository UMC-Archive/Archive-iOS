//
//  ArtistViewController.swift
//  Archive
//
//  Created by 이수현 on 1/19/25.
//

import UIKit

class ArtistViewController: UIViewController {
    private let musicService = MusicService()
    private let artistView = ArtistView()
    private let artistData = ArtistDummyModel.dummy()
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>?
    private let gradientLayer = CAGradientLayer()
    private let artist: String
    private let album: String
    private var data: ArtistInfoReponseDTO?
    private var similarArtist: [(ArtistInfoReponseDTO, AlbumInfoReponseDTO)]? // 비슷한 아티스트
    private var popularMusic: [(MusicInfoResponseDTO, AlbumInfoReponseDTO, String)]? // 아티스트 인기곡
    
    
    private var libraryService = LibraryService()
    
    init(artist: String, album: String) {
        self.artist = artist
        self.album = album
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = artistView
        setNavigationBar()
        setAction()
        setDataSource()
        setSnapshot()
        
        // 아티스트 정보 조회
        postArtistInfo(artist: artist, album: album)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
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
        guard let artist = data else {
            print("album data is nil")
            return
        }
        libraryService.artistPost(artistId: artist.id ){[weak self] result in
            guard let self = self else{return}
            switch result {
            case .success(let response):
                print(response)
                Task {
                    print("-----------------albumPost 성공")
                }
            case .failure(let error):
                // 네트워크 연결 실패 얼럿
                print("-----------fail")
                let alert = NetworkAlert.shared.getAlertController(title: error.description)
                self.present(alert, animated: true)
            }
        }
    }
    
    private func setDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: artistView.collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case let .ArtistPopularMusic(music, album, artist):     // 아티스트 인기곡
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VerticalCell.id, for: indexPath)
                (cell as? VerticalCell)?.configPopularMusic(music: music, artist: artist)
                return cell
            case .SameArtistAnotherAlbum(let item): // 앨범 둘러보기
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCell.id, for: indexPath)
                (cell as? BannerCell)?.configAlbum(data: item)
                return cell
            case .MusicVideo(let item):  // 아티스트 뮤직 비디오
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MusicVideoCell.id, for: indexPath)
                (cell as? MusicVideoCell)?.config(data: item)
                return cell
            case let .SimilarArtist(artist, album):  // 비슷한 아티스트
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CircleCell.id, for: indexPath)
                
                // 탭 제스처
                let tapGesture = CustomTapGesture(target: self, action: #selector(self.tapSimilarArtist(_:)))
                tapGesture.artist = artist.name
                tapGesture.album = album.title
                cell.addGestureRecognizer(tapGesture)
                
                (cell as? CircleCell)?.config(artist: artist)
                return cell
            default:
                return UICollectionViewCell()
            }
        })
        
        dataSource?.supplementaryViewProvider = {[weak self] collectionView, kind, indexPath in
            guard let self = self,
                  let section = self.dataSource?.sectionIdentifier(for: indexPath.section),
                    let item = dataSource?.snapshot(for: section) else {return UICollectionReusableView() }
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderView.id, for: indexPath)
            // 버튼에 UIAction 추가
            (headerView as? HeaderView)?.detailButton.addAction(UIAction(handler: { [weak self] _ in
                guard let self = self else { return }
                self.handleDetailButtonTap(for: section, item: item)
            }), for: .touchUpInside)

            switch section {
            case .Banner(let headerTitle):
                (headerView as? HeaderView)?.config(headerTitle: headerTitle)
            case .Vertical(let headerTitle):
                (headerView as? HeaderView)?.config(headerTitle: headerTitle)
            case .MusicVideoCell(let headerTitle):
                (headerView as? HeaderView)?.config(headerTitle: headerTitle)
            case .Circle(let headerTitle):
                (headerView as? HeaderView)?.config(headerTitle: headerTitle)
            default:
                return UICollectionReusableView()
            }
            
            return headerView
        }
    }
    
    // 비슷한 아티스트 탭 제스처
    @objc private func tapSimilarArtist(_ sender: CustomTapGesture) {
        guard let artist = sender.artist, let album = sender.album else {return}
        let nextVC = ArtistViewController(artist: artist, album: album)
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    // 자세히 보기 버튼
    private func handleDetailButtonTap(for section: Section, item: NSDiffableDataSourceSectionSnapshot<Item>) {
        let nextVC = DetailViewController(section: section, item: item)
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    private func setSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        let popularMusicSection = Section.Vertical(.ArtistPopularMusic) // 아티스트 인기곡
        let sameArtistAnotherAlbumSection = Section.Banner(.SameArtistAnotherAlbum) // 앨범 둘러보기
        let musicVideoSection = Section.MusicVideoCell(.MusicVideo) // 뮤직 비디오
        let similarArtistSection = Section.Circle(.SimilarArtist)   // 다른 비슷한 아티스트
        
        snapshot.appendSections([popularMusicSection, sameArtistAnotherAlbumSection, musicVideoSection, similarArtistSection])
        
        // 아티스트 인기곡
        if let popularMusic = popularMusic {
            let popularMusicItem = popularMusic.map{Item.ArtistPopularMusic($0.0, $0.1, $0.2)}
            snapshot.appendItems(popularMusicItem, toSection: popularMusicSection)
        }
        
        // 앨범 둘러보기
        let anotherAlbumItem = artistData.albumList.map{Item.SameArtistAnotherAlbum($0)}
        snapshot.appendItems(anotherAlbumItem, toSection: sameArtistAnotherAlbumSection)
        
        // 뮤직 비디오
        let musicVideoItem = artistData.musicVideoList.map{Item.MusicVideo($0)}
        snapshot.appendItems(musicVideoItem, toSection: musicVideoSection)
        
        // 다른 비슷한 아티스트
        if let similarArtist = similarArtist {
            let similarArtistItem = similarArtist.map{Item.SimilarArtist($0.0, $0.1)}
            snapshot.appendItems(similarArtistItem, toSection: similarArtistSection)
        }
        
        dataSource?.apply(snapshot)
    }
    
    
    private func setAction() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleLabelLines))
        artistView.descriptionLabel.addGestureRecognizer(tapGesture)
    }
    
    @objc private func toggleLabelLines() {
        // numberOfLines 토글
        let newNumberOfLines = artistView.descriptionLabel.numberOfLines == 0 ? 3 : 0

        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.artistView.descriptionLabel.numberOfLines = newNumberOfLines
            self?.artistView.layoutIfNeeded() // 애니메이션 반영
        }
    }
    
    
    // 아티스트 정보 가져오기 API
    func postArtistInfo(artist: String, album: String){
        musicService.artist(artist: artist, album: album){ [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                guard let response = response else {return}
                self.data = response
                
                // 아티스트 큐레이션
                postArtistCuration(artistId: response.id)
                
                // 비슷한 아티스트 조회
                getSimilarArtist(artistId: response.id)
                
                // 아티스트 인기곡
                getArtistPopularMusic(artistId: response.id)
                
                // 앨범 둘러보기
                getSameArtistAnotherAlbum(artistId: response.id)

            case .failure(let error):
                // 네트워크 연결 실패 얼럿
                let alert = NetworkAlert.shared.getAlertController(title: error.description)
                self.present(alert, animated: true)
                print("실패: \(error.description)")
            }
        }
    }
    
    // 아티스트 큐레이션 API
    func postArtistCuration(artistId: String){
        musicService.artistCuration(artistId: artistId){ [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                guard let response = response, let artistData = data else {return}
                artistView.config(artistInfo: artistData, curation: response)

            case .failure(let error):
                // 네트워크 연결 실패 얼럿
                let alert = NetworkAlert.shared.getAlertController(title: error.description)
                self.present(alert, animated: true)
                print("실패: \(error.description)")
            }
        }
    }
    
    // 비슷한 아티스트 조회
    private func getSimilarArtist(artistId: String){
        musicService.similarArtist(aristId: artistId) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let response):
                guard let response = response else { return }
                self.similarArtist = response.map{($0.artist, $0.album)}
                self.setDataSource()
                self.setSnapshot()
            case .failure(let error):
                let alert = NetworkAlert.shared.getAlertController(title: error.description)
                self.present(alert, animated: true)
            }
        }
    }
    
    // 아티스트 인기곡 API
    private func getArtistPopularMusic(artistId: String) {
        musicService.artistPopularMusic(artistId: artistId) { [weak self] result in
            guard let self = self else {return}
            
            switch result {
            case .success(let response):
                guard let response = response else { return }
                popularMusic = response.map{($0.music, $0.album, $0.artist)}
                self.setDataSource()
                self.setSnapshot()
                
            case .failure(let error):
                let alert = NetworkAlert.shared.getAlertController(title: error.description)
                self.present(alert, animated: true)
            }
        }
    }
    
    // 앨범 둘러보기 API
    private func getSameArtistAnotherAlbum(artistId: String) {
        musicService.sameArtistAnotherAlbum(artistId: artistId) { [weak self] result in
            guard let self = self else {return}
            
            switch result {
            case .success(let response):
                guard let response = response else { return }
                print("getSameArtistAnotherAlbum() 성공")
//                self.setDataSource()
//                self.setSnapshot()
                
            case .failure(let error):
                let alert = NetworkAlert.shared.getAlertController(title: error.description)
                self.present(alert, animated: true)
            }
        }
    }
}
