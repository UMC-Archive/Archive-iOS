//
//  ExploreViewController.swift
//  Archive
//
//  Created by 이수현 on 1/17/25.
//

import UIKit

class ExploreViewController: UIViewController {
    private let exploreView = ExploreView()
    private var dataSource : UICollectionViewDiffableDataSource<Section, Item>?
    
    private let musicService = MusicService()
    private let albumService = AlbumService()
    
    private let musicData = MusicDummyModel.dummy()
    private let albumData = AlbumDummyModel.dummy()
    private var hiddenMusic: [(HiddenMusicResponse, ExploreRecommendAlbum, String)]?
    private var recommendMusic: [(ExploreRecommendMusic, ExploreRecommendAlbum, String)]?
    private var recommendAlbumData: [(ExploreRecommendAlbum, String)]?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
        view = exploreView
        
        setDataSource()
        setDelegate()
        setRecapIndex()
        
        // 숨겨진 명곡 조회 API
        getHiddenMusic()
        
        // 추천 음악 API
        getRecommendMusic()
        
        // 당신을 위한 앨범 추천 API
        getRecommendAlbum()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let contentHeight = calculateScrollViewHeight()
        exploreView.contentView.snp.updateConstraints { make in
            make.height.equalTo(contentHeight)
        }
        
        exploreView.layoutIfNeeded()
    }
    
    // 컬렉션 뷰 높이 구하는 함수
    private func calculateCollectionViewHeight() -> CGFloat {
        // 각 섹션의 높이 정의
        let verticalSectionHeight: CGFloat = 275 + (10 * 3) + 45 // 그룹 높이 + 간격 + 헤더
        let bannerSectionHeight: CGFloat = 186 + 45 // 그룹 높이 + 헤더
        let interSectionSpacing: CGFloat = 40 // 섹션 간 간격

        // 섹션 높이 합계
        let totalCollectionViewHeight = (verticalSectionHeight * 2) + bannerSectionHeight + (interSectionSpacing * 2)
        return totalCollectionViewHeight
    }
    
    // 스크롤 뷰의 높이 구하는 ㅇ함수
    private func calculateScrollViewHeight() -> CGFloat {
        // collectionView 전체 높이 계산
        let collectionViewHeight = calculateCollectionViewHeight()

        // recapCollectionView 높이
        let recapCollectionViewHeight: CGFloat = 333

        // recapCollectionView와 collectionView 사이 간격
        let gapBetweenRecapAndCollectionView: CGFloat = 17

        // scrollView 전체 높이
        let totalHeight = recapCollectionViewHeight + gapBetweenRecapAndCollectionView + collectionViewHeight
        return totalHeight
    }


    
    private func setRecapIndex(){
        // 뷰가 로드된 직후 1번 인덱스로 이동
        DispatchQueue.main.async {
            let recapIndexPath = IndexPath(item: 1, section: 0)
            self.exploreView.recapCollectionView.scrollToItem(at: recapIndexPath, at: .centeredHorizontally, animated: false)
        }
    }
    
    private func setDelegate() {
        exploreView.recapCollectionView.dataSource = self
    }
    
    private func setDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: exploreView.collectionView, cellProvider: {[weak self] collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case let .ExploreRecommendMusic(music, album, artist): // 당신을 위한 추천곡
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VerticalCell.id, for: indexPath)
                guard let verticalCell = cell as? VerticalCell else {return cell}
                verticalCell.configRecommendMusic(music: music, artist: artist)
                
                // 앨범 탭 제스처
                let tapAlbumGesture = CustomTapGesture(target: self, action: #selector(self?.TapAlbumImageGesture(_:)))
                tapAlbumGesture.artist = artist
                tapAlbumGesture.album = album.title
                verticalCell.imageView.addGestureRecognizer(tapAlbumGesture)
                
                // 아티스트 탭 제스처
                let tapArtistGesture = CustomTapGesture(target: self, action: #selector(self?.TapArtistLabelGesture(_:)))
                tapArtistGesture.artist = artist
                tapArtistGesture.album = album.title
                verticalCell.artistYearLabel.addGestureRecognizer(tapArtistGesture)
                
                return cell
            case let .HiddenMusic(music, album, artist): // 숨겨진 명곡
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VerticalCell.id, for: indexPath)
                guard let verticalCell = cell as? VerticalCell else {return cell}
                verticalCell.configHiddenMusic(music: music, artist: artist)
                
                // 앨범 탭 제스처
                let tapAlbumGesture = CustomTapGesture(target: self, action: #selector(self?.TapAlbumImageGesture(_:)))
                tapAlbumGesture.artist = artist
                tapAlbumGesture.album = album.title
                verticalCell.imageView.addGestureRecognizer(tapAlbumGesture)
                
                // 아티스트 탭 제스처
                let tapArtistGesture = CustomTapGesture(target: self, action: #selector(self?.TapArtistLabelGesture(_:)))
                tapArtistGesture.artist = artist
                tapArtistGesture.album = album.title
                verticalCell.artistYearLabel.addGestureRecognizer(tapArtistGesture)
                
                return cell
            case let .ExploreRecommendAlbum(album, artist): // 당신을 위한 추천 앨범
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCell.id, for: indexPath)
                guard let bannerCell = cell as? BannerCell else {return cell}
                bannerCell.configRecommendAlbum(album: album, artist: artist)
                
                // 앨범 탭 제스처
                let tapAlbumGesture = CustomTapGesture(target: self, action: #selector(self?.TapAlbumImageGesture(_:)))
                tapAlbumGesture.artist = artist
                tapAlbumGesture.album = album.title
                bannerCell.imageView.addGestureRecognizer(tapAlbumGesture)
                
                // 아티스트 탭 제스처
                let tapArtistGesture = CustomTapGesture(target: self, action: #selector(self?.TapArtistLabelGesture(_:)))
                tapArtistGesture.artist = artist
                tapArtistGesture.album = album.title
                bannerCell.artistLabel.addGestureRecognizer(tapArtistGesture)
                
                return cell
            default:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VerticalCell.id, for: indexPath)
                return cell
            }
        })
        
        dataSource?.supplementaryViewProvider = {[weak self] collectionView, kind, indexPath in
            guard let self = self,
                  let section = self.dataSource?.sectionIdentifier(for: indexPath.section),
                  let item = self.dataSource?.snapshot(for: section)
            else {
                return UICollectionReusableView()
            }
            
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
            default:
                return UICollectionReusableView()
            }
            
            return headerView
        }
        
    }
    
    // 앨범 버튼
    @objc private func TapAlbumImageGesture(_ sender: CustomTapGesture) {
        guard let album = sender.album, let artist = sender.artist else { return }
        let nextVC = AlbumViewController(artist: artist, album: album)
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    // 아티스트 버튼
    @objc private func TapArtistLabelGesture(_ sender: CustomTapGesture) {
        guard let album = sender.album, let artist = sender.artist else { return }
        let nextVC = ArtistViewController(artist: artist, album: album)
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    // 자세히 보기 버튼
    private func handleDetailButtonTap(for section: Section, item: NSDiffableDataSourceSectionSnapshot<Item>) {
        let nextVC = DetailViewController(section: section, item: item)
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    private func setSnapShot() {

        // 스냅샷 생성
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        
        // 섹션 정의
        let recommendMusicSection = Section.Vertical(.RecommendMusic) // 당신을 위한 추천곡
        let recommendAlbumSection = Section.Banner(.RecommendAlbum) // 당신을 위한 앨범 추천
        let hiddenMusicSection = Section.Vertical(.HiddenMusic) // 숨겨진 명곡
        
        
        // 섹션 추가
        snapshot.appendSections([recommendMusicSection, recommendAlbumSection, hiddenMusicSection])

        // 추천곡
        if let recommendMusic = recommendMusic {
            let recommendMusicItem = recommendMusic.map{Item.ExploreRecommendMusic($0.0, $0.1, $0.2)}// 추천곡
            snapshot.appendItems(recommendMusicItem, toSection: recommendMusicSection)
        }
       
        // 숨겨진 명곡
        if let hiddenMusic = hiddenMusic {
            let hiddenMusicItem = hiddenMusic.map{Item.HiddenMusic($0.0, $0.1, $0.2)}
            snapshot.appendItems(hiddenMusicItem, toSection: hiddenMusicSection)
        }
        
        // 당신을 위한 추천 앨범
        if let recommendAlbumData = recommendAlbumData {
            let recommendAlbumItem = recommendAlbumData.map{Item.ExploreRecommendAlbum($0.0, $0.1)}
            snapshot.appendItems(recommendAlbumItem, toSection: recommendAlbumSection)
        }
        
        dataSource?.apply(snapshot)
    }
    
    // 당신을 위한 추천곡 API
    func getRecommendMusic() {
        musicService.recommendMusic(){ [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                guard let response = response else {return}
                print("recommendMusic() 성공")
                self.recommendMusic = response.map{($0.music, $0.album, $0.artist)}
                self.setDataSource()
                self.setSnapShot()
                
            case .failure(let error):
                // 네트워크 연결 실패 얼럿
                let alert = NetworkAlert.shared.getAlertController(title: error.description)
                self.present(alert, animated: true)
                print("실패: \(error.description)")
            }
        }
    }
    
    // 당신을 위한 앨범 추천 API
    func getRecommendAlbum() {
        albumService.recommendAlbum(){ [weak self] result in // 반환값 result의 타입은 Result<[RecommendAlbumResponseDTO]?, NetworkError>
            guard let self = self else { return }
            switch result {
            case .success(let response): // 네트워크 연결 성공 시 데이터를 UI에 연결 작업
                guard let response = response else {return}
                print("getRecommendAlbum")
                self.recommendAlbumData = response.map{($0.album, $0.artist)}
                setDataSource()
                setSnapShot()
            case .failure(let error): // 네트워크 연결 실패 시 얼럿 호출
                // 네트워크 연결 실패 얼럿
                let alert = NetworkAlert.shared.getAlertController(title: error.description) // 얼럿 생성
                self.present(alert, animated: true) // 얼럿 띄우기
                print("실패: \(error.description)")
            }
        }
    }
    
    // 숨겨진 명곡 조회 API
    func getHiddenMusic() {
        musicService.hiddenMusic(){ [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                guard let response = response else {return}
                print("getHiddenMusic() 성공")
                self.hiddenMusic = response.map{($0.music, $0.album, $0.artist)}
                self.setDataSource()
                self.setSnapShot()
            case .failure(let error):
                // 네트워크 연결 실패 얼럿
                let alert = NetworkAlert.shared.getAlertController(title: error.description)
                self.present(alert, animated: true)
                print("실패: \(error.description)")
            }
        }
    }
}


extension ExploreViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case exploreView.recapCollectionView:
            return 3
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case exploreView.recapCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecapCollectionViewCell.recapCollectionViewIdentifier, for: indexPath)
            (cell as? RecapCollectionViewCell)?.config(data: musicData[indexPath.row])
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}
