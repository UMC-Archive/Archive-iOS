//
//  ForYouAlbumRecommendVC.swift
//  Archive
//
//  Created by 손현빈 on 2/18/25.
//
import UIKit

class ForYouAlbumRecommendVC : UIViewController {
    private var recommendMusic: [AlbumRecommendAlbumResponseDTO]?
    private let libraryService = LibraryService()
   
   private let forYouRecommendAlbumView = ForYouAlbumRecommendView()
    override func loadView() {
        self.view = forYouRecommendAlbumView
    }
    init(recommendMusic : [AlbumRecommendAlbumResponseDTO]){
        self.recommendMusic = recommendMusic
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupActions()
        fetchAlbum()
        forYouRecommendAlbumView.leftArrowButton.addTarget(self,action : #selector(leftButtonTapped), for: .touchUpInside)
        
        self.navigationController?.navigationBar.isHidden = true
        self.view.layoutIfNeeded()
    }
private func setupCollectionView(){
 
    forYouRecommendAlbumView.ForYouRecommendAlbumCollectionView.delegate = self
    forYouRecommendAlbumView.ForYouRecommendAlbumCollectionView.dataSource = self
    
    forYouRecommendAlbumView.ForYouRecommendAlbumCollectionView.register(ForYouRecommendAlbumCell.self, forCellWithReuseIdentifier : ForYouRecommendAlbumCell.identifier)
    forYouRecommendAlbumView.ForYouRecommendAlbumCollectionView.allowsMultipleSelection = true
    
    }

    @objc private func leftButtonTapped(){
        print("눌림!")
//        let moveVC = MusicSegmentVC(segmentIndexNum: 3, lyrics: nil, nextTracks: <#[SelectionResponseDTO]#>)
//        navigationController?.pushViewController(moveVC,animated: true)
        self.navigationController?.popViewController(animated: true)
    }
    private func setupActions(){
        
    }
    private func fetchAlbum(){
        
    }
    
}
extension ForYouAlbumRecommendVC : UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recommendMusic?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == forYouRecommendAlbumView.ForYouRecommendAlbumCollectionView {
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ForYouRecommendAlbumCell.identifier, for: indexPath) as? ForYouRecommendAlbumCell else {
                fatalError("ForYouRecommendAlbumCell 에러")
            }
            guard let trackData = recommendMusic?[indexPath.row] else { return cell }
            cell.configure(dto: trackData)
            
            // 노래 재생 제스처
            let musicGesture = CustomTapGesture(target: self, action: #selector(self.musicPlayingGesture(_:)))
            musicGesture.musicTitle = trackData.album.title
            musicGesture.musicId = trackData.album.id
            musicGesture.musicImageURL = trackData.album.image
            musicGesture.artist = trackData.artist
            cell.titleLabel.isUserInteractionEnabled = true
            cell.imageView.isUserInteractionEnabled = true
            cell.titleLabel.addGestureRecognizer(musicGesture)
            cell.imageView.addGestureRecognizer(musicGesture)
            
            // 아티스트 탭 제스처
            let tapArtistGesture = CustomTapGesture(target: self, action: #selector(self.tapArtistLabelGesture(_:)))
            tapArtistGesture.artist = trackData.artist
            tapArtistGesture.album = trackData.album.title
            cell.artistLabel.isUserInteractionEnabled = true
            cell.artistLabel.addGestureRecognizer(tapArtistGesture)
            
            return cell
            
        }
        
        return UICollectionViewCell()
    }
}



// 제스처 함수 - Extension
extension ForYouAlbumRecommendVC: UIGestureRecognizerDelegate  {
    
    // 제스처 설정 (overflowView - hidden 처리)
    private func setGesture() {
        // overflow 버튼 외 다른 영역 터치 시 overflowView 사라짐
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissOverflowView(_:)))
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self   // ✅ 제스처 델리게이트 설정 (버튼 터치는 무시하기 위해)
        forYouRecommendAlbumView.addGestureRecognizer(tapGesture)
    }
    
    // overflow 버튼 클릭 시 실행될 메서드
    @objc private func touchUpInsideOverflowButton(_ sender: UIButton) {
        // 버튼의 superview를 통해 셀 찾기
        guard let cell = sender.superview as? VerticalCell ?? sender.superview?.superview as? VerticalCell else { return
        }

        // isHidden 토글
        cell.overflowView.isHidden.toggle()
    }
    
    // overflow 버튼 영역 외부 터치 실행될 메서드
    @objc private func dismissOverflowView(_ gesture: UITapGestureRecognizer) {
        let touchLocation = gesture.location(in: forYouRecommendAlbumView)
        
        // 현재 보이는 모든 셀을 순회하면서 overflowView 숨기기
        for cell in forYouRecommendAlbumView.ForYouRecommendAlbumCollectionView.visibleCells {
            if let verticalCell = cell as? VerticalCell {
                if !verticalCell.overflowView.frame.contains(touchLocation) {
                    verticalCell.overflowView.isHidden = true
                }
            }
        }
    }
    
    // 라이브러리로 이동 액션
    @objc private func goToLibrary(_ sender: CustomTapGesture) {
        guard let musicId = sender.musicId else { return }
        postAddMusicInLibary(musicId: musicId)

    }
    
    // 보관함 노래 추가 함수
    private func postAddMusicInLibary(musicId: String) {
        libraryService.musicPost(musicId: musicId){ [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success:
                // 성공 alert 띄우기
                let alert = LibraryAlert.shared.getAlertController(type: .music)
                self.present(alert, animated: true)
            case .failure(let error):
                // 네트워크 연결 실패 얼럿
                let alert = NetworkAlert.shared.getAlertController(title: error.description)
                self.present(alert, animated: true)
            }
        }
    }
    
    // 노래 재생 제스처
    @objc private func musicPlayingGesture(_ sender: CustomTapGesture) {
        guard let musicId = sender.musicId,
              let musicTitle = sender.musicTitle,
              let musicImageURL = sender.musicImageURL,
              let artist = sender.artist
        else { return }
        
        KeychainService.shared.save(account: .musicInfo, service: .musicId, value: musicId)
        KeychainService.shared.save(account: .musicInfo, service: .musicTitle, value: musicTitle)
        KeychainService.shared.save(account: .musicInfo, service: .musicImageURL, value: musicImageURL)
        KeychainService.shared.save(account: .musicInfo, service: .artist, value: artist)
//        (self.tabBarController as? TabBarViewController)?.setFloatingView()
        
        (self.presentingViewController as? MusicLoadVC)?.musicLoad(playMusic: true, artist: artist, music: musicTitle)
        
        print("musicPlayingGesture")
    }
    
    // 앨범 버튼
    @objc private func tapGoToAlbumGesture(_ sender: CustomTapGesture) {
        guard let album = sender.album, let artist = sender.artist else { return }
        print("TapAlbumImageGesture: \(album), \(artist)")
        let nextVC = AlbumViewController(artist: artist, album: album)
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    // 아티스트 버튼
    @objc private func tapArtistLabelGesture(_ sender: CustomTapGesture) {
        guard let album = sender.album, let artist = sender.artist else { return }
        let nextVC = ArtistViewController(artist: artist, album: album)
        self.navigationController?.pushViewController(nextVC, animated: true)
        
        print("tapArtistLabelGesture")
    }
    
    // 자세히 보기 버튼
    private func tapDetailButton(for section: Section, item: NSDiffableDataSourceSectionSnapshot<Item>) {
        let nextVC = DetailViewController(section: section, item: item)
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}

extension ForYouAlbumRecommendVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 160, height: 206)
    }
}
