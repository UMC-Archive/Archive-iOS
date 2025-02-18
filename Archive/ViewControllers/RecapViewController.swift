//
//  RecapViewController.swift
//  Archive
//
//  Created by 송재곤 on 1/14/25.
//

import UIKit

class RecapViewController: UIViewController, UIGestureRecognizerDelegate {
    private let dummyData = MusicDummyModel.dummy()
    let cellSize = CGSize(width: 258, height: 258)
    var minItemSpacing: CGFloat = 1
    let cellCount = 3
    var previousIndex = 0
    
    
    let gradient = CAGradientLayer()
    
    private let rootView = RecapView()
    private let userService = UserService()
    public var recapResponseData: [RecapResponseDTO]?
    public var recentResponseData: [RecentMusicResponseDTO]?
    public var genreResponseDate: [GenrePreferenceResponseDTO]?
    public var genreArray: [String]?
    private let libraryService = LibraryService()
    
    init(data: [GenrePreferenceResponseDTO]){
        self.genreResponseDate = data
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = rootView
        self.navigationController?.navigationBar.isHidden = true
        
        
        
        // 뷰가 로드된 직후 1번 인덱스로 이동
        DispatchQueue.main.async {
            let recapIndexPath = IndexPath(item: 1, section: 0)
            let genreIndexPath = IndexPath(item: 2, section: 0)
            self.rootView.recapCollectionView.scrollToItem(at: recapIndexPath, at: .centeredHorizontally, animated: false)
            self.rootView.genreCollectionView.scrollToItem(at: genreIndexPath, at: .centeredHorizontally, animated: false)
        }
        
        buildGradient()
        setDelegateAndDataSource()
        controlTapped()
        
        
        self.view.layoutIfNeeded()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getRecap()
        getGenre()
        setData()
    }
    public func setData(){
        let nickName = KeychainService.shared.load(account: .userInfo, service: .nickname) ?? "닉네임"
        
        rootView.genreInfoLabel.text = "2025 상반기 \(nickName)님이 가장 즐겨들은 장르\n 상위 5가지로 CD를 제작했어요. "
        rootView.genreTasteLabel.text = "\(nickName)님의 장르 취향은..."
        rootView.CDInfoLabel.text = "\(nickName)님이 올해 상반기 가장 많이 들은 음악이에요"
    }
    
    private func updateGenreLabel() {
        if let layout = rootView.genreCollectionView.collectionViewLayout as? CarouselLayout {
            let centerX = rootView.genreCollectionView.contentOffset.x + rootView.genreCollectionView.bounds.width / 2
            let visibleCellsAttributes = rootView.genreCollectionView.indexPathsForVisibleItems.compactMap { indexPath -> UICollectionViewLayoutAttributes? in
                return layout.layoutAttributesForItem(at: indexPath)
            }
            
            // 화면 중앙에 가장 가까운 셀을 찾음
            if let closestAttributes = visibleCellsAttributes.min(by: {
                abs($0.center.x - centerX) < abs($1.center.x - centerX)
            }) {
                
                let indexPath = closestAttributes.indexPath
                
                // genreResponseDate가 nil이 아닌 경우에만 처리
                if let genreResponseDate = genreResponseDate, indexPath.row < genreResponseDate.count {
                    rootView.genreTasteLabel2.text = genreResponseDate[indexPath.row].name
                }
            }
        }
    }


    private func controlTapped(){
        rootView.navigationView.popButton.addTarget(self, action: #selector(recapButtonTapped), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(headerButtonTapped))
        rootView.headerButton.isUserInteractionEnabled = true // 제스처 인식 활성화
        rootView.headerButton.addGestureRecognizer(tapGesture)
        
        
        // overflow 버튼 외 다른 영역 터치 시 overflowView 사라짐
        let overflowElseTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissOverflowView(_:)))
        overflowElseTapGesture.cancelsTouchesInView = false
        overflowElseTapGesture.delegate = self   // ✅ 제스처 델리게이트 설정 (버튼 터치는 무시하기 위해)
        rootView.addGestureRecognizer(overflowElseTapGesture)
    }
    // overflow 버튼 클릭 시 실행될 메서드
    @objc private func touchUpInsideOverflowButton(_ sender: UIButton) {
        // 버튼의 superview를 통해 셀 찾기
        guard let cell = sender.superview as? MusicVerticalCell ?? sender.superview?.superview as? MusicVerticalCell else { return }

        // isHidden 토글
        cell.overflowView.isHidden.toggle()
    }
    // overflow 버튼 영역 외부 터치 실행될 메서드
    @objc private func dismissOverflowView(_ gesture: UITapGestureRecognizer) {
        let touchLocation = gesture.location(in: rootView)
        
        // 현재 보이는 모든 셀을 순회하면서 overflowView 숨기기
        for cell in rootView.collectionView.visibleCells {
            if let verticalCell = cell as? MusicVerticalCell {
                if !verticalCell.overflowView.frame.contains(touchLocation) {
                    verticalCell.overflowView.isHidden = true
                }
            }
        }
    }
    @objc private func goToLibrary(_ sender: CustomTapGesture) {
        guard let musicId = sender.musicId else {
            print("nil")
            return }
        print("-------musicId\(musicId)")
        
        libraryService.musicPost(musicId: musicId){ [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                print("postMusicInfo() 성공")
                print(response)
                Task{
                    print("-----------------musicPost 성공")
                }
            case .failure(let error):
                // 네트워크 연결 실패 얼럿
                print("-----------fail")
                let alert = NetworkAlert.shared.getAlertController(title: error.description)
                self.present(alert, animated: true)
            }
        }
    }
    @objc func recapButtonTapped(){
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func headerButtonTapped() {
        
        let viewController = RecapCollectionViewViewController()
        viewController.responseData = self.recapResponseData
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func setDelegateAndDataSource() {
        rootView.recapCollectionView.dataSource = self
        rootView.recapCollectionView.delegate = self
        rootView.genreCollectionView.dataSource = self
        rootView.genreCollectionView.delegate = self
        rootView.collectionView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // rootView의 크기가 업데이트된 후 gradient의 프레임을 설정
        gradient.frame = rootView.CDView.bounds
    }
    
    func buildGradient() {
        
        let genreColors: [String: UIColor] = [
            "Pop": UIColor.Pop ?? .black,
            "HipHop": UIColor.HipHop ?? .black,
            "Afrobeats": UIColor.Afrobeats ?? .black,
            "Ballad": UIColor.Ballad ?? .black,
            "Disco": UIColor.Disco ?? .black,
            "Electronic": UIColor.Electronic ?? .black,
            "Funk": UIColor.Funk ?? .black,
            "Indie": UIColor.Indie ?? .black,
            "Jazz": UIColor.Jazz ?? .black,
            "Latin": UIColor.Latin ?? .black,
            "Phonk": UIColor.Phonk ?? .black,
            "Punk": UIColor.Punk ?? .black,
            "Rock": UIColor.Rock ?? .black,
            "Trot": UIColor.Trot ?? .black,
            "Other": UIColor.Other ?? .black
        ]
        
        gradient.type = .conic
        if let data = genreResponseDate, data.count == 5 {
            gradient.colors = [
                genreColors[data[0].name]?.cgColor ?? UIColor.white,
                genreColors[data[1].name]?.cgColor ?? UIColor.white,
                genreColors[data[2].name]?.cgColor ?? UIColor.white,
                genreColors[data[3].name]?.cgColor ?? UIColor.white,
                genreColors[data[4].name]?.cgColor ?? UIColor.white,
                genreColors[data[0].name]?.cgColor ?? UIColor.white,
            ]
        }else{
            gradient.colors = [
                UIColor.dance_100?.cgColor ?? UIColor.red,
                UIColor.hiphop_100?.cgColor,
                UIColor.dance_100?.cgColor ?? UIColor.red,
                UIColor.RnB_100?.cgColor,
                UIColor.dance_100?.cgColor ?? UIColor.red,
                UIColor.dance_100?.cgColor
            ]
        }
       
        
        gradient.locations = [0.0, 0.08, 0.25, 0.42, 0.59, 0.76, 0.92, 1.0]
        gradient.startPoint = CGPoint(x: 0.5, y: 0.5) // 중심점
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)   // conic 그라데이션은 중심을 공유
        
        
        rootView.CDView.layer.addSublayer(gradient)
    }
    
    private func getRecap(){
        userService.getRecap(){ [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                print("recentMusicInfo() 성공")
                print(response)
                Task{
                    
                    let viewController = RecapCollectionViewViewController()
                    self.recapResponseData = response
                    self.rootView.collectionView.reloadData()
                    self.rootView.recapCollectionView.reloadData()
                    viewController.responseData = response
                }
            case .failure(let error):
                // 네트워크 연결 실패 얼럿
                let alert = NetworkAlert.shared.getAlertController(title: error.description)
                self.present(alert, animated: true)
            }
        }
    }
    private func getGenre(){
        userService.getGenrePreference(){ [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                print("------------- 장르")
                print(response)
                Task{
                    
                    self.genreResponseDate = response
                    self.rootView.genreCollectionView.reloadData()
                    
                }
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
        (self.tabBarController as? TabBarViewController)?.setFloatingView()
    }
    
    // 아티스트 버튼
    @objc private func tapArtistLabelGesture(_ sender: CustomTapGesture) {
        guard let album = sender.album, let artist = sender.artist else {return }
        let nextVC = ArtistViewController(artist: artist, album: album)
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    // 앨범 버튼
    @objc private func tapGoToAlbumGesture(_ sender: CustomTapGesture) {
        guard let album = sender.album, let artist = sender.artist else { return }
        print("TapAlbumImageGesture: \(album), \(artist)")
        let nextVC = AlbumViewController(artist: artist, album: album)
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
}

extension RecapViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case rootView.recapCollectionView :
            return 3
        case rootView.genreCollectionView :
            return genreResponseDate?.count ?? 5
        case rootView.collectionView :
            return recapResponseData?.count ?? 0
        default :
            fatalError("Unknown collection view")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case rootView.recapCollectionView:
            guard let cell = rootView.recapCollectionView.dequeueReusableCell(withReuseIdentifier: "recapCollectionViewIdentifier", for: indexPath) as? RecapCollectionViewCell else {
                fatalError("Failed to dequeue RecapCollectionViewCell")
            }
            guard let data = recapResponseData else {
                let dummy = MusicDummyModel.dummy()
                cell.config(data: dummy[indexPath.row])
                return cell
            }
            guard let recapData = recapResponseData, indexPath.row < min(3, recapData.count) else {
                return UICollectionViewCell() // 안전한 기본 반환
            }
            
            cell.recapConfig(data: recapData[indexPath.row])
            
            return cell
        case rootView.genreCollectionView:
            guard let cell = rootView.genreCollectionView.dequeueReusableCell(withReuseIdentifier: "genreRecommendedCollectionViewIdentifier", for: indexPath)as? GenreRecommendedCollectionViewCell else {
                fatalError("Failed to dequeue genreRecommendedCollectionViewCell")
            }
            
            guard let data = genreResponseDate else {
                let dummy = GenreRecommendedModel.dummy()
                cell.configExample(image: dummy[indexPath.row].AlbumImage)
                return cell
            }
            cell.config(data: data[indexPath.row])
            rootView.genreTasteLabel2.text = data[2].name
            return cell
        case rootView.collectionView:
            guard let cell = rootView.collectionView.dequeueReusableCell(withReuseIdentifier: "MusicVerticalCell", for: indexPath)as? MusicVerticalCell else {
                fatalError("Failed to dequeue CollectionViewCell")
            }
            //            let dummy = MusicDummyModel.dummy()
            //            cell.config(albumURL: dummy[indexPath.row].albumURL, musicTitle: dummy[indexPath.row].musicTitle, artist: dummy[indexPath.row].artist, year: String(dummy[indexPath.row].year))
               
            cell.config(albumURL: recapResponseData?[indexPath.row].image ?? "CDSample", musicTitle: recapResponseData?[indexPath.row].title ?? "", artist: recapResponseData?[indexPath.row].artists ?? "", year:recapResponseData?[indexPath.row].releaseYear ?? 0)
            
            // overflow 버튼 로직 선택
            cell.overflowButton.addTarget(self, action: #selector(self.touchUpInsideOverflowButton(_:)), for: .touchUpInside)
            cell.setOverflowView(type: .other)
            
            // 노래 보관함으로 이동 탭 제스처
            let tapGoToLibraryGesture = CustomTapGesture(target: self, action: #selector(self.goToLibrary(_:)))
            tapGoToLibraryGesture.musicId = recapResponseData?[indexPath.row].id
            cell.overflowView.libraryButton.addGestureRecognizer(tapGoToLibraryGesture)
            
            // 앨범 으로 이동 제스처
            let tapAlbumGesture = CustomTapGesture(target: self, action: #selector(self.tapGoToAlbumGesture(_:)))
            tapAlbumGesture.artist = recapResponseData?[indexPath.row].artists
            tapAlbumGesture.album = recapResponseData?[indexPath.row].albumTitle
            cell.overflowView.goToAlbumButton.isUserInteractionEnabled = true
            cell.overflowView.goToAlbumButton.addGestureRecognizer(tapAlbumGesture)
            
            // 노래 재생 제스처
            let musicGesture = CustomTapGesture(target: self, action: #selector(self.musicPlayingGesture(_:)))
            musicGesture.musicTitle = recapResponseData?[indexPath.row].title
            musicGesture.musicId = recapResponseData?[indexPath.row].id
            musicGesture.musicImageURL = recapResponseData?[indexPath.row].image
            musicGesture.artist = recapResponseData?[indexPath.row].artists
            cell.touchView.isUserInteractionEnabled = true
            cell.touchView.addGestureRecognizer(musicGesture)


        // 아티스트 탭 제스처
            let tapArtistGesture = CustomTapGesture(target: self, action: #selector(self.tapArtistLabelGesture(_:)))
            tapArtistGesture.artist = recapResponseData?[indexPath.row].artists
            tapArtistGesture.album = recapResponseData?[indexPath.row].albumTitle
            cell.artistYearLabel.isUserInteractionEnabled = true
            cell.artistYearLabel.addGestureRecognizer(tapArtistGesture)
            return cell
        default:
            fatalError("Unknown collection view")
        }
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
            updateGenreLabel()
        }

}
        


