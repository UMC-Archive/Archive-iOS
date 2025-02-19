//
//  MusicLoadVC.swift
//  Archive
//
//  Created by 손현빈 on 1/30/25.
//

import UIKit
import AVFoundation

class MusicLoadVC: UIViewController {

    private let musicLoadView = MusicLoadView()
    private var player: AVPlayer?
    private let musiceservice = MusicService()
    private let userService = UserService()
    public var musicInfo : MusicResponseDTO?
    private var nextTracks: [SelectionResponseDTO] = []
    private var currentTrackIndex: Int = 0
    
    private var musicSegmentVC: MusicSegmentVC = MusicSegmentVC(segmentIndexNum: 0, lyrics: nil, nextTracks: [])
    private var music: String
    private var artist: String
    let libraryService = LibraryService()
    private var playerItemObserver: Any?    // playerItemObserver가 있어야 시간 흐르는걸 인식함
    
    // 초기 반복재생 버튼 상태
    private var repeatState: MusicLoadView.RepeatState = .RepeatAll
    
    override func loadView() {
        self.view = musicLoadView // MusicLoadView를 메인 뷰로 설정
    }
    
    init(music: String, artist: String) {
        self.music = music
        self.artist = artist
        super.init(nibName: nil, bundle: nil)
        
        setupActions()
        loadNextTracks()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        setupActions()
    }
    
    public func musicLoad(playMusic: Bool = false, artist: String, music: String) {
//            let artist = "NewJeans" // 임시 데이터
//            let song = "Supernatural"

        musiceservice.musicInfo(artist: artist, music: music) { [weak self] (result: Result<MusicResponseDTO?, NetworkError>) in
                switch result {
                case .success(let response):
                    guard let data = response else { return }
                    self?.musicInfo = data
                    
                    // UI 업데이트
//                    DispatchQueue.main.async {
//                        self?.musicLoadView.updateUI(
//                            imageUrl: data.music.image,
//                            title: data.music.title,
//                            artist: data.artist.name,
//                            musicUrl: data.music.music
//                        )
//                    }
                    
                    NotificationCenter.default.post(
                                 name: .didChangeMusic,
                                 object: nil,
                                 userInfo: [
                                     "title": data.music.title,
                                     "artist": data.artist.name,
                                     "image": data.music.image,
                                     "isPlaying": playMusic,
                                     "lyrics": data.music.lyrics
                                 ]
                             )
                    if playMusic {
                        self?.resetPlayer()
                        self?.playPauseMusic()
                    }
                case .failure(let error):
                    // 네트워크 연결 실패 얼럿
                    let alert = NetworkAlert.shared.getAlertController(title: error.description)
                    self?.present(alert, animated: true)
                    print(" 음악 정보 API 오류: \(error)")
                }
            }
        }
    // 다음 트랙들 미리 async로 불러오고
    private func loadNextTracks() {
        musiceservice.selection { [weak self] result in
            switch result {
            case .success(let response):
                guard let data = response else { return }
                self?.nextTracks = data
                
                let lyrics = self?.musicInfo?.music.lyrics.components(separatedBy: "\n").map { $0.replacingOccurrences(of: "\\[.*?\\]", with: "")}
                self?.musicSegmentVC.setInfo(segmentIndex: 1, lyrics: lyrics, nextTracks: data)
            
//                DispatchQueue.main.async {
//                    
//                    print("성공")
//                }
            case .failure(let error):
                print("다음 트랙 로드 실패: \(error)")
                let alert = NetworkAlert.shared.getRetryAlertController(title: "다음 트랙 불러오기") {
                    self?.loadNextTracks()
                }
                self?.present(alert, animated: true)
            }
        }
    }
    // 다음 곡 재생 (음악 재생)
    @objc private func playNextTrack() {
        let nextIndex = currentTrackIndex + 1
        if nextIndex < nextTracks.count {
            playTrack(at: nextIndex)
        } else {
            print("마지막 곡입니다.")
            if nextTracks.isEmpty {
                let alert = UIAlertController(title: "다음 곡 재생", message: "곡을 불러오고 있습니다.", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "확인", style: .default)
                alert.addAction(alertAction)
                self.present(alert, animated: true)
            }
            if repeatState == .RepeatAll {
                playTrack(at: 0) // 다시 처음 곡부터 재생
            }
            
            
        }
    }
    @objc private func playBackTrack(){
        let backIndex = currentTrackIndex - 1
        if backIndex > 0 {
            playTrack(at: backIndex)
        }
        else{
            print("첫번째 곡입니다.")
            if repeatState == .RepeatAll {
                playTrack(at: 10)
            }
        }
        
    }
    private func playTrack(at index: Int) {
        guard index >= 0, index < nextTracks.count else { return }
        resetPlayer()
        currentTrackIndex = index
        let track = nextTracks[index]
        guard let musicUrl = URL(string: track.music.music) else { return }

        player = AVPlayer(url: musicUrl)
        player?.play()
        
       let musicId = track.music.id
        postPlayingRecord(musicId: musicId) // 음악 재생 기록
        
        // 뮤직 정보 가져오기
        musicLoad(playMusic: true, artist: track.artist, music: track.music.title)

        musicLoadView.updateUI(
            imageUrl: track.music.image,
            title: track.music.title,
            artist: track.artist,
            musicUrl: track.music.music
        )
        //  현재 재생 중인 곡 정보 Notification 전송 -> 가사에서 사용하려고
           NotificationCenter.default.post(
               name: .didChangeMusic,
               object: nil,
               userInfo: [
                   "title": track.music.title,
                   "artist": track.artist,
                   "lyrics": track.music.lyrics, // 가사도 같이 보내줌
                   "image": track.music.image,
                   "isPlaying": true,
               ]
           )
        musicLoadView.updatePlayButton(isPlaying: true)
        addPeriodicTimeObserver()
        observePlayerItemDidEnd()
    }
    private func resetPlayer() {
        //  기존 player observer 해제 및 초기화
        if let timeObserverToken = timeObserverToken {
            player?.removeTimeObserver(timeObserverToken)
            self.timeObserverToken = nil
        }
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem)

        player?.pause()
        player = nil
    }

    

    private func setupActions() {
        // 하단 메뉴의 각각의 라벨에 제스처 추가
        guard let bottomMenuSubviews = musicLoadView.bottomMenuStackView.arrangedSubviews as? [UILabel] else {
            return
        }
        // 재생 버튼 누를 시에 음악 재생
        musicLoadView.playPauseButton.addTarget(self, action: #selector(playPauseMusic), for: .touchUpInside)
          // 슬라이더 사용자가 움직이게 할때
        musicLoadView.progressSlider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        
        // 반복재생 뷰
        musicLoadView.repeatButton.addTarget(self, action: #selector(changeRepeatMode), for: .touchUpInside)
        // 다음 곡 재생 버튼 -> 음악 재생
        musicLoadView.nextButton.addTarget(self, action: #selector(playNextTrack), for: .touchUpInside)
        musicLoadView.shuffleButton.addTarget(self,action: #selector(shuffleTracks),
                                              for: .touchUpInside)
        
        musicLoadView.previousButton.addTarget(self,action: #selector(playBackTrack), for: .touchUpInside)
        // 다음 트랙
        let nextTrackTapGesture = UITapGestureRecognizer(target: self, action: #selector(goToNextTrack))
        bottomMenuSubviews[0].isUserInteractionEnabled = true
        bottomMenuSubviews[0].addGestureRecognizer(nextTrackTapGesture)

        // 가사
        let lyricsTapGesture = UITapGestureRecognizer(target: self, action: #selector(goToLyrics))
        bottomMenuSubviews[1].isUserInteractionEnabled = true
        bottomMenuSubviews[1].addGestureRecognizer(lyricsTapGesture)

        // 추천 콘텐츠
        let recommendTapGesture = UITapGestureRecognizer(target: self, action: #selector(goToRecommend))
        bottomMenuSubviews[2].isUserInteractionEnabled = true
        bottomMenuSubviews[2].addGestureRecognizer(recommendTapGesture)
        
        
        // 뒤로 가기
        musicLoadView.popButton.addTarget(self, action: #selector(popButton), for: .touchUpInside)
        // 앨범 으로 이동 제스처
        let GoToLibraryGesture = CustomTapGesture(target: self, action: #selector(self.goToLibrary(_:)))
        GoToLibraryGesture.musicId = musicInfo?.music.id

        self.musicLoadView.titleIcon.isUserInteractionEnabled = true
        self.musicLoadView.titleIcon.addGestureRecognizer(GoToLibraryGesture)
        
        // 음악 재생 플로팅 뷰 구독
        NotificationCenter.default.addObserver(self, selector: #selector(handleMusicChange(_:)), name: .didChangeMusic, object: nil)

    }
    // 라이브러리로 이동 액션
    @objc private func goToLibrary(_ sender: CustomTapGesture) {
//        guard let musicId = sender.musicId else { return }
        guard let musicId = musicInfo?.music.id else { return }
        postAddMusicInLibary(musicId: musicId)

    }
    // 보관함 노래 추가 함수
    private func postAddMusicInLibary(musicId: String) {
        libraryService.musicPost(musicId: musicId){ [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success:
                let alert = LibraryAlert.shared.getAlertController(type: .music)
                self.present(alert, animated: true)
                // 성공 alert 띄우기
            case .failure(let error):
                // 네트워크 연결 실패 얼럿
                let alert = NetworkAlert.shared.getAlertController(title: error.description)
                self.present(alert, animated: true)
            }
        }
    }
    
    // 뒤로 가기 액션
    @objc private func popButton() {
        self.dismiss(animated: true)
    }

    // 다음 트랙 화면으로 이동
    @objc public func goToNextTrack() {
        let lyrics = musicInfo?.music.lyrics.components(separatedBy: "\n").map { $0.replacingOccurrences(of: "\\[.*?\\]", with: "")}
//        let nextTrackVC = MusicSegmentVC(segmentIndexNum: 0, lyrics: lyrics, nextTracks: self.nextTracks)
//        nextTrackVC.segmentIndexNum = 0
//        present(nextTrackVC, animated: true)
        musicSegmentVC.setInfo(segmentIndex: 0, lyrics: lyrics, nextTracks: self.nextTracks)
        let nextVC = UINavigationController(rootViewController: musicSegmentVC)
        present(nextVC,animated: true)
    }
//    private var lyricsVC: MusicSegmentVC?

    @objc private func goToLyrics() {
//        if let lyricsVC = lyricsVC {
//            lyricsVC.segmentIndexNum = 1
//            present(lyricsVC, animated: true)
//        } else {
//            guard let currentTrack = musicInfo else { return }
//            
//            let newLyricsVC = MusicSegmentVC(
//                segmentIndexNum: 1,
////                musicTitle: currentTrack.title,
////                artistName: currentTrack.id
//                lyrics: musicInfo?.music.lyrics.components(separatedBy: "\n").map { $0.replacingOccurrences(of: "\\[.*?\\]", with: "", options: .regularExpression) }, nextTracks: self.nextTracks
//
//            )
//            
//            lyricsVC = newLyricsVC // 생성된 거 저장해두기
//            present(newLyricsVC, animated: true)
        
        let lyrics = musicInfo?.music.lyrics.components(separatedBy: "\n").map { $0.replacingOccurrences(of: "\\[.*?\\]", with: "")}
        musicSegmentVC.setInfo(segmentIndex: 1, lyrics: lyrics, nextTracks: self.nextTracks)
        let nextVC = UINavigationController(rootViewController: musicSegmentVC)
        present(nextVC,animated: true)
    }
    

    // 가사 화면으로 이동
//    @objc private func goToLyrics() {
//        guard let currentTrack = musicInfo else { return }
//        let lyricsVC = MusicSegmentVC(
//            segmentIndexNum: 1,
//            musicTitle: currentTrack.title,
//            artistName: currentTrack.id // id가 아티스트명이라면
//        )
//        present(lyricsVC, animated: true)
//    }
//

    // 추천 콘텐츠 화면으로 이동
    @objc private func goToRecommend() {
//        guard let musicInfo = musicInfo else { return }
//        let lyrics = musicInfo.music.lyrics.components(separatedBy: "\n").map { $0.replacingOccurrences(of: "\\[.*?\\]", with: "")}
//        let recommendVC = MusicSegmentVC(segmentIndexNum: 2, lyrics: lyrics, nextTracks: self.nextTracks)
//        recommendVC.segmentIndexNum = 2
//        let nextVC = UINavigationController(rootViewController: recommendVC)
//        present(nextVC,animated: true)
        
        let lyrics = musicInfo?.music.lyrics.components(separatedBy: "\n").map { $0.replacingOccurrences(of: "\\[.*?\\]", with: "")}
        musicSegmentVC.setInfo(segmentIndex: 2, lyrics: lyrics, nextTracks: self.nextTracks)
        let nextVC = UINavigationController(rootViewController: musicSegmentVC)
        present(nextVC,animated: true)
    }

    // 재생 버튼 누를 시에 음악 재생하기
    @objc public func playPauseMusic() {
        guard let musicInfo = musicInfo,
              let url = URL(string: musicInfo.music.music)
        else {
            print(" 음악 URL이 유효하지 않습니다.")
            return
        }
        

        let musicId = musicInfo.music.id
        var isPlaying = true
        
        if player == nil {
            player = AVPlayer(url: url)
            addPeriodicTimeObserver()
            self.postPlayingRecord(musicId: musicId) // 음악 재생 기록
        }

        if player?.timeControlStatus == .playing {
            player?.pause()
            isPlaying = false
                musicLoadView.updatePlayButton(isPlaying: false)
        } else {
            player?.play()
            isPlaying = true
                musicLoadView.updatePlayButton(isPlaying: true)
        }

        
        //  현재 재생 중인 곡 정보 Notification 전송 -> 가사에서 사용하려고
           NotificationCenter.default.post(
               name: .didChangeMusic,
               object: nil,
               userInfo: [
                  "title": musicInfo.music.title,
                   "artist": musicInfo.artist.name,
                   "lyrics": musicInfo.music.lyrics, // 가사도 같이 보내줌
                   "image": musicInfo.music.image,
                   "isPlaying": isPlaying,
               ]
           )
    }
    
    // 반복재생 누를시에 바뀌는거
    @objc private func changeRepeatMode(){
        switch repeatState {
         case .RepeatAll:
             repeatState = .Norepeat
         case .Norepeat:
             repeatState = .RepeatOne
         case .RepeatOne:
             repeatState = .RepeatAll
         }
        musicLoadView.updateRepeatButton(state: repeatState)

        
    }
    // 자연스럽게 다음 노래 나오게 하는거
    private func observePlayerItemDidEnd() {
        
        NotificationCenter.default.addObserver(self,
            selector: #selector(trackDidFinishPlaying),
            name: .AVPlayerItemDidPlayToEndTime,
            object: player?.currentItem)
    }
    
    @objc private func trackDidFinishPlaying() {
        print("trackDidFinishPlaying 호출")
        musicLoadView.updatePlayButton(isPlaying: false)
        switch repeatState {
        case .RepeatAll:
            playNextTrack() // 다음 곡 재생
        case .RepeatOne:
            playTrack(at: currentTrackIndex) // 같은 곡 반복 재생
        case .Norepeat:
            if currentTrackIndex < nextTracks.count - 1 {
                playNextTrack()
            } else {
                print("재생 종료")
            }
        }
    }

    
    @objc private func shuffleTracks(){
        
    }
//    // 트랙 받아오고 셔플
//    private func loadNextTracks() {
//        musiceservice.selection { [weak self] result in
//            switch result {
//            case .success(let response):
//                guard let data = response else { return }
//                DispatchQueue.main.async {
//                    self?.nextTracks = data
//                    self?.shuffleTracks()
//                    self?.playTrack(at: 0) // 첫 번째 곡부터 시작
//                }
//            case .failure(let error):
//                print("다음 트랙 로드 실패: \(error)")
//            }
//        }
//    }

   
//    // 다음 노래 버튼 누르면
//    @objc private func goToNextTrack() {
//        let nextIndex = currentTrackIndex + 1
//        if nextIndex < nextTracks.count {
//            playTrack(at: nextIndex)
//        } else {
//            print("마지막 곡입니다.")
//        }
//    }
    // 전 노래 버튼 누르면
//    @objc private func goToPreviousTrack() {
//        let previousIndex = currentTrackIndex - 1
//        if previousIndex >= 0 {
//            playTrack(at: previousIndex)
//        } else {
//            print("처음 곡입니다.")
//        }
//    }
    // 셔플
//    @objc private func shuffleAndPlay() {
//        shuffleTracks()
//        playTrack(at: 0)
//    }
//    // 시간에 따라 움직이기 위해 시간 관찰자 생성하기
    private var timeObserverToken: Any?

    private func addPeriodicTimeObserver() {
        guard let player = player else { return }

        let interval = CMTime(seconds: 1.0, preferredTimescale: 1)
        timeObserverToken = player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            guard let self = self else { return }

            let currentTime = CMTimeGetSeconds(time)
            let duration = CMTimeGetSeconds(player.currentItem?.duration ?? CMTime(value: 1, timescale: 1))

            // 시간/슬라이더 업데이트
            self.musicLoadView.progressSlider.value = Float(currentTime / duration)
            self.musicLoadView.currentTimeLabel.text = self.formatTime(seconds: currentTime)
            self.musicLoadView.totalTimeLabel.text = self.formatTime(seconds: duration)
        }
    }
// 시간 계산하는 함수
    private func formatTime(seconds: TimeInterval) -> String {
        let minutes = Int(seconds) / 60
        let seconds = Int(seconds) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    // 슬라이더 사용자가 움직이게 하는 부분
    @objc private func sliderValueChanged(_ sender: UISlider) {
        guard let player = player, let duration = player.currentItem?.duration else { return }
        let durationSeconds = CMTimeGetSeconds(duration)
        let newTime = CMTime(seconds: Double(sender.value) * durationSeconds, preferredTimescale: 1)
        player.seek(to: newTime)
    }

    
// 메모리 관리 측면에서 사라지게 하는거 시간 관찰자가 있을 필요가 없으니까
    deinit {
        if let timeObserverToken = timeObserverToken {
            player?.removeTimeObserver(timeObserverToken)
        }
    }

    
    // 음악 재생 기록 API
    private func postPlayingRecord(musicId: String) {
        guard let musicId = Int(musicId) else { return }
        let param = UserPlayingRecordRequestDTO(musicId: musicId)
        userService.playingRecord(parameter: param) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success:
                break
            case .failure(let error):
                let alert = NetworkAlert.shared.getAlertController(title: error.description)
                self.present(alert, animated: true)
            }
        }
    }
    
    // 음악이 변경될 떄마다 호출됨
    @objc private func handleMusicChange(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
            let title = userInfo["title"] as? String,
            let artist = userInfo["artist"] as? String,
            let image = userInfo["image"] as? String,
            let isPlaying = userInfo["isPlaying"] as? Bool
        else {
            print("handleMusicChange - Notification 데이터 없음")
            return
        }
        
        // 데이터 전달
        musicLoadView.updateUI(imageUrl: image, title: title, artist: artist)
        musicLoadView.updatePlayButton(isPlaying: isPlaying)
    }
    
}
extension Notification.Name {
    static let didChangeMusic = Notification.Name("didChangeMusic")
}
