//
//  MyPageViewController.swift
//  Archive
//
//  Created by 송재곤 on 1/14/25.
//

import UIKit

class MyPageViewController: UIViewController {
    
    let rootView = MyPageView()
    let gradient = CAGradientLayer()
    let userService = UserService()
    let musicService = MusicService()
    public var genreResponseDate: [GenrePreferenceResponseDTO]?
    var musicInfo: MusicInfoResponseDTO? = nil
    var recentlyData: [RecentMusicResponseDTO]?
    var recentlyPlayData: [RecentPlayMusicResponseDTO]?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setProfileImage() // 프로필 설정 함수
        getGenre()
        getRecentMusic()
        getRecentlyPlayedMusic()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.view = rootView
        
        self.navigationController?.navigationBar.isHidden = true
        
        buildGradient()
        controlTapped()
        setDataSource()
        
        self.view.layoutIfNeeded()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // rootView의 크기가 업데이트된 후 gradient의 프레임을 설정
        gradient.frame = rootView.CDView.bounds
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
                    
                }
            case .failure(let error):
                // 네트워크 연결 실패 얼럿
                let alert = NetworkAlert.shared.getAlertController(title: error.description)
                self.present(alert, animated: true)
            }
        }
    }
    
    private func setDataSource(){
        rootView.recordCollectionView.dataSource = self
        rootView.recentCollectionView.dataSource = self
    }
    private func controlTapped(){
        rootView.goRecapButton.addTarget(self, action: #selector(recapButtonTapped), for: .touchUpInside)
        // headerButton에 UITapGestureRecognizer 추가
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(headerButtonTapped))
        rootView.headerButton.isUserInteractionEnabled = true // 제스처 인식 활성화
        rootView.headerButton.addGestureRecognizer(tapGesture)
        
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(headerButtonTapped2))
        rootView.headerButton2.isUserInteractionEnabled = true // 제스처 인식 활성화
        rootView.headerButton2.addGestureRecognizer(tapGesture2)
        
        let tapGesture3 = UITapGestureRecognizer(target: self, action: #selector(arrowButtonTapped))
        rootView.arrowButton.isUserInteractionEnabled = true // 제스처 인식 활성화
        rootView.arrowButton.addGestureRecognizer(tapGesture3)
        
        rootView.topView.exploreIconButton.addTarget(self, action: #selector(exploreIconTapped), for: .touchUpInside)
    }
    @objc func exploreIconTapped(){
        let viewController = DatePickerViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    @objc func recapButtonTapped(){
        let viewController = RecapViewController(data: genreResponseDate ?? [])
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    // 제스처에 대응하는 함수
    @objc private func headerButtonTapped() {
        
        let viewController = ListenRecordViewController()
        viewController.responseData = self.recentlyPlayData
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    // 제스처에 대응하는 함수
    @objc private func headerButtonTapped2() {
        let viewController = RecentMusicViewController()
        viewController.responseData = self.recentlyData
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    @objc private func arrowButtonTapped() {
        let viewController = ProfileChangeViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    func buildGradient() {
        
        
        gradient.type = .conic
        if let data = genreResponseDate, data.count == 5 {
            gradient.colors = [
                UIColor(named: "\(data[0].name)") ?? .white,
                UIColor(named: "\(data[1].name)") ?? .white,
                UIColor(named: "\(data[2].name)") ?? .white,
                UIColor(named: "\(data[3].name)") ?? .white,
                UIColor(named: "\(data[4].name)") ?? .white,
                UIColor(named: "\(data[0].name)") ?? .white,
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

    private func getRecentMusic(){
        userService.RecentlyMusic(){ [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                print("------------- 최근추가 노래")
                print(response)
                Task{
                    

                    self.recentlyData = response
                    self.rootView.recentCollectionView.reloadData()
                  
                }
            case .failure(let error):
                // 네트워크 연결 실패 얼럿
                let alert = NetworkAlert.shared.getAlertController(title: error.description)
                self.present(alert, animated: true)
            }
        }
    }
    private func getRecentlyPlayedMusic(){
        userService.RecentlyPlayedMusic(){[weak self] result in
            guard let self else {return}
            switch result {
            case .success(let response):
                print("------------- 최근들은 노래")
                print(response)
                Task{
                    
                    self.recentlyPlayData = response
                    self.rootView.recordCollectionView.reloadData()
                }
            case .failure(let error):
                // 네트워크 연결 실패 얼럿
                let alert = NetworkAlert.shared.getAlertController(title: error.description)
                self.present(alert, animated: true)
            }
        }
    }
}
    

extension MyPageViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView{
        case rootView.recordCollectionView :
            return recentlyPlayData?.count ?? 0
        case rootView.recentCollectionView :
            return recentlyData?.count ?? 3
        default :
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView{
        case rootView.recordCollectionView :
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "listenRecordCollectionViewIdentifier", for: indexPath)as? ListenRecordCollectionViewCell else {
                fatalError("Failed to dequeue ListenRecordCollectionViewCell")
            }
            if let data = recentlyPlayData{
                cell.configData(image: data[indexPath.row].musicImage, albumName: data[indexPath.row].musicTitle, artist: data[indexPath.row].artists.first?.artistName ?? "아티스트")
            }else{
                let dummy = ListenRecordModel.dummy()
                
                cell.config(image: dummy[indexPath.row].albumImage, albumName: dummy[indexPath.row].albumName)
            }
            return cell
            
        case rootView.recentCollectionView :
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "listenRecordCollectionViewIdentifier", for: indexPath)as? ListenRecordCollectionViewCell else {
                fatalError("Failed to dequeue ListenRecordCollectionViewCell")
            }
            if let data = recentlyData{
                cell.configData(image: data[indexPath.row].music.image, albumName: data[indexPath.row].music.title, artist: data[indexPath.row].music.artist.name)
            }else{
                let dummy = ListenRecordModel.dummy()
                
                cell.config(image: dummy[indexPath.row].albumImage, albumName: dummy[indexPath.row].albumName)
            }
            return cell
        default :
            fatalError("Unknown collection view")
            
        }
        
    }
    
    // 프로필 이미지 설정 함수
    private func setProfileImage() {
        if let profileImage = KeychainService.shared.load(account: .userInfo, service: .profileImage) {
            rootView.topView.config(profileImage: profileImage)
            self.rootView.profileView.kf.setImage(with: URL(string: profileImage))
        }
    }

}
