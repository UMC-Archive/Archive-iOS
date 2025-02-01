//
//  HomeViewController.swift
//  Archive
//
//  Created by 이수현 on 1/13/25.
//

import UIKit

class HomeViewController: UIViewController {
    private let musicService = MusicService() // 예시
    private let userService = UserService()
    
    
    private let homeView = HomeView()
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>?
    private let musicData = MusicDummyModel.dummy()
    private let pointData = PointOfViewDummyModel.dummy()
    private var recommendMusic: [(RecommendMusic, String)]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = homeView
        setDataSource()
        setSnapShot()
        
        // 추천 음악 API
        getRecommendMusic()
        
        // 음악 정보 가져오기 API
//        postMusicInfo(artist: "IU", music: "Love poem") // 예시
        
        
        // 이메일 인증 번호 전송 API
//        getSendVerificationCode(email: "tngus0673@naver.com")
        
        // 회원가입 API
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let inactiveDate = dateFormatter.string(from: date)
        
        let parameter = SignUpRequestDTO(nickname: "example", email: "aasdlkkc123sl123l@naver.com", password: "example", status: "active", socialType: "local", inactiveDate: inactiveDate, artists: [1], genres: [1])
//        postSignUp(image: .cdSample, parameter: parameter)
        
//        getGenreInfo()
        buttonTapped()

    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("homeView has disappeared")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    private func buttonTapped(){
        homeView.topView.exploreIconButton.addTarget(self, action: #selector(exploreIconTapped), for: .touchUpInside)
    }
    @objc func exploreIconTapped(){
        let viewController = DatePickerViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func setDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: homeView.collectionView, cellProvider: {[weak self] collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .ArchiveItem(let item): // 아카이브
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BigBannerCell.id, for: indexPath)
                if let bigBannerCell = cell as? BigBannerCell {
                    bigBannerCell.config(album: item)
                    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self?.TapArtistLabelGesture))
                    bigBannerCell.artistLabel.addGestureRecognizer(tapGesture)
                }
                return cell
            case .PointItem(let item): // 탐색했던 시점
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PointOfViewCell.id, for: indexPath)
                (cell as? PointOfViewCell)?.config(data: item)
                return cell
            case .FastSelectionItem(let item), .RecentlyListendMusicItem(let item):// 빠른 선곡 / 최근 들은 노래
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCell.id, for: indexPath)
                if let bannerCell = cell as? BannerCell {
                    
                    bannerCell.configMusic(data: item)
                    
                    // 앨범 탭 제스처
                    let tapAlbumGesture = UITapGestureRecognizer(target: self, action: #selector(self?.TapAlbumImageGesture))
                    bannerCell.imageView.addGestureRecognizer(tapAlbumGesture)
                    
                    // 아티스트 탭 제스처
                    let tapArtistGesture = UITapGestureRecognizer(target: self, action: #selector(self?.TapArtistLabelGesture))
                    bannerCell.artistLabel.addGestureRecognizer(tapArtistGesture)
                }
                return cell
            case .RecommendMusicItem(let (music, artist)): // 추천곡
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VerticalCell.id, for: indexPath)
                if let verticalCell = cell as? VerticalCell {
                    verticalCell.configRecommendMusic(music: music, artist: artist)
                    
                    // 앨범 탭 제스처
                    let tapAlbumGesture = UITapGestureRecognizer(target: self, action: #selector(self?.TapAlbumImageGesture))
                    verticalCell.imageView.addGestureRecognizer(tapAlbumGesture)
                    
                    // 아티스트 탭 제스처
                    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self?.TapArtistLabelGesture))
                    verticalCell.artistYearLabel.addGestureRecognizer(tapGesture)
                }
                return cell
            case .RecentlyAddMusicItem(let item): //  최근 추가 노래
               let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VerticalCell.id, for: indexPath)
               if let verticalCell = cell as? VerticalCell {
                   verticalCell.config(data: item)
                   
                   // 앨범 탭 제스처
                   let tapAlbumGesture = UITapGestureRecognizer(target: self, action: #selector(self?.TapAlbumImageGesture))
                   verticalCell.imageView.addGestureRecognizer(tapAlbumGesture)
                   
                   // 아티스트 탭 제스처
                   let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self?.TapArtistLabelGesture))
                   verticalCell.artistYearLabel.addGestureRecognizer(tapGesture)
                }
               return cell
            default:
                return UICollectionViewCell()
            }
        })
        
        dataSource?.supplementaryViewProvider = {[weak self] collectionView, kind, indexPath in
            guard let self = self,
                    let section = self.dataSource?.sectionIdentifier(for: indexPath.section),
                    let item = dataSource?.snapshot(for: section)
            else {
                return UICollectionReusableView()
            }
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderView.id, for: indexPath)
            
            // 버튼에 UIAction 추가, 탐색 시점 섹션 제외
            if section != .PointOfView(.PointOfView) {
                (headerView as? HeaderView)?.detailButton.addAction(UIAction(handler: { [weak self] _ in
                    guard let self = self else {return}
                    self.handleDetailButtonTap(for: section, item: item)
                }), for: .touchUpInside)
            }

            switch section {
            case .BigBanner(let headerTitle):
                (headerView as? HeaderView)?.config(headerTitle: headerTitle)
            case .PointOfView(let headerTitle):
                (headerView as? HeaderView)?.config(headerTitle: headerTitle)
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
    @objc private func TapAlbumImageGesture() {
        let nextVC = AlbumViewController()
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    // 아티스트 버튼
    @objc private func TapArtistLabelGesture() {
        let nextVC = ArtistViewController()
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
        let archiveSection = Section.BigBanner(.Archive) // 당신을 위한 아카이브 섹션
        let pointOfViewSection = Section.PointOfView(.PointOfView) // 탐색했던 시점
        let fastSelectionSection = Section.Banner(.FastSelection) // 빠른 선곡
        let recommendSection = Section.Vertical(.RecommendMusic) // 당신을 위한 추천곡
        let RecentlyListendMusicSection = Section.Banner(.RecentlyListendMusic) // 최근 들은 노래
        let RecentlyAddMusicSection = Section.Vertical(.RecentlyAddMusic) // 최근 추가한 노래
        
        
        // 섹션 추가
        snapshot.appendSections([archiveSection, pointOfViewSection, fastSelectionSection,
                                 recommendSection, RecentlyListendMusicSection,
                                 RecentlyAddMusicSection])
        
        let archiveItem = musicData.map{Item.ArchiveItem($0)}
        snapshot.appendItems(archiveItem, toSection: archiveSection)
        
        let pointItem = pointData.map{Item.PointItem($0)}
        snapshot.appendItems(pointItem, toSection: pointOfViewSection)
        
        let fastSelectionItem = musicData.map{Item.FastSelectionItem($0)}
        snapshot.appendItems(fastSelectionItem, toSection: fastSelectionSection)

        // 추천곡
        if let recommendMusic = recommendMusic {
            let recommendMusicItem = recommendMusic.map{Item.RecommendMusicItem($0.0, $0.1)}
            snapshot.appendItems(recommendMusicItem, toSection: recommendSection)
        }
        
        let RecentlyListendMusicItem = musicData.map{Item.RecentlyListendMusicItem($0)}
        snapshot.appendItems(RecentlyListendMusicItem, toSection: RecentlyListendMusicSection)
        
        let RecentlyAddMusicItem = musicData.map{Item.RecentlyAddMusicItem($0)}
        snapshot.appendItems(RecentlyAddMusicItem, toSection: RecentlyAddMusicSection)
        
        dataSource?.apply(snapshot)
    }
    
    // 당신을 위한 추천곡 API
    func getRecommendMusic() {
        musicService.recommendMusic(){ [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                Task {
                    guard let response = response else {return}
                    print("recommendMusic() 성공")
                    self.recommendMusic = response.map{($0.music, $0.artist)}
                    self.setDataSource()
                    self.setSnapShot()
                }

            case .failure(let error):
                // 네트워크 연결 실패 얼럿
                let alert = NetworkAlert.shared.getAlertController(title: error.description)
                self.present(alert, animated: true)
                print("실패: \(error.description)")
            }
        }
    }
    
    
    // 음악 정보 가져오기 API
    func postMusicInfo(artist: String, music: String) {
        musicService.musicInfo(artist: artist, music: music){ [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                print("postMusicInfo() 성공")
                print(response?.musicUrl)
                Task{
//                    LoginViewController.keychain.set(response.token, forKey: "serverAccessToken")
//                    LoginViewController.keychain.set(response.nickname, forKey: "userNickname")
//                    self.goToNextView()
                }
            case .failure(let error):
                // 네트워크 연결 실패 얼럿
                let alert = NetworkAlert.shared.getAlertController(title: error.description)
                self.present(alert, animated: true)
                print("실패: \(error.description)")
            }
        }
    }
    

    // 이메일 인증 번호 전송 API
    func getSendVerificationCode(email: String) {
        userService.sendVerificationCode(email: email){ [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response): // response == cipherCode
                print("getSendVerificationCode() 성공")
                print(response)
                if let cipherCode = response {
                    // cipherCode 키체인 저장 후 인증 확인 API에 사용
                }
                
                Task{
                    //                    LoginViewController.keychain.set(response.token, forKey: "serverAccessToken")
                    //                    LoginViewController.keychain.set(response.nickname, forKey: "userNickname")
                    //                    self.goToNextView()
                }
            case .failure(let error):
                // 네트워크 연결 실패 얼럿
                let alert = NetworkAlert.shared.getAlertController(title: error.description)
                self.present(alert, animated: true)
                print("실패: \(error.description)")
            }
        }
    }
    
    // 이메일 인증 번호 확인 API
    func postCheckVerificationCode(cipherCode: String, code: String) {
        let param = CheckVerificationCodeRequestDTO(cipherCode: cipherCode, code: code)
        userService.checkVerificationCode(parameter: param){ [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                // 이 API는 성공이나 실패나 result가 null로 오기 떄문에 .success일 경우 확인 코드 검증된 거임
                print("postCheckVerificationCode() 성공")
                print(response)
                Task{
                    //                    LoginViewController.keychain.set(response.token, forKey: "serverAccessToken")
                    //                    LoginViewController.keychain.set(response.nickname, forKey: "userNickname")
                    //                    self.goToNextView()
                }
            case .failure(let error):
                // 네트워크 연결 실패 얼럿
                let alert = NetworkAlert.shared.getAlertController(title: error.description)
                self.present(alert, animated: true)
                print("실패: \(error.description)")
            }
        }
    }
    
    // 회원가입 API
    func postSignUp(image: UIImage, parameter: SignUpRequestDTO) {
        userService.signUp(image: image, parameter: parameter){ [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                // 이 API는 성공이나 실패나 result가 null로 오기 떄문에 .success일 경우 확인 코드 검증된 거임
                print("postSignUp() 성공")
                print(response)
                Task{
                    //                    LoginViewController.keychain.set(response.token, forKey: "serverAccessToken")
                    //                    LoginViewController.keychain.set(response.nickname, forKey: "userNickname")
                    //                    self.goToNextView()
                }
            case .failure(let error):
                // 네트워크 연결 실패 얼럿
                let alert = NetworkAlert.shared.getAlertController(title: error.description)
                self.present(alert, animated: true)
                print("실패: \(error.description)")
            }
        }
    }
    
    // 장르 정보 조회
    func getGenreInfo() {
        musicService.genreInfo(){ [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                // 이 API는 성공이나 실패나 result가 null로 오기 떄문에 .success일 경우 확인 코드 검증된 거임
                print("getGenreInfo() 성공")
                print(response)
                Task{
                    //                    LoginViewController.keychain.set(response.token, forKey: "serverAccessToken")
                    //                    LoginViewController.keychain.set(response.nickname, forKey: "userNickname")
                    //                    self.goToNextView()
                }
            case .failure(let error):
                // 네트워크 연결 실패 얼럿
                let alert = NetworkAlert.shared.getAlertController(title: error.description)
                self.present(alert, animated: true)
                print("실패: \(error.description)")
            }
        }
    }
}
