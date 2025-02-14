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
    private var musicInfo : MusicInfoResponseDTO?
    private var music: String
    private var artist: String
    
    override func loadView() {
        self.view = musicLoadView // MusicLoadView를 메인 뷰로 설정
    }
    
    init(artist: String = "NewJeans", music: String = "Supernatural") {
        self.artist = artist
        self.music = music
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
        musicLoad()
    }
    

    private func musicLoad() {
//            let artist = "NewJeans" // 임시 데이터
//            let song = "Supernatural"

        musiceservice.musicInfo(artist: artist, music: music) { [weak self] (result: Result<MusicInfoResponseDTO?, NetworkError>) in
                switch result {
                case .success(let response):
                    guard let data = response else { return }
                    self?.musicInfo = data
                    
                    // UI 업데이트
                    DispatchQueue.main.async {
                        self?.musicLoadView.updateUI(
                            imageUrl: data.image,
                            title: data.title,
                            artist: data.id,
                            musicUrl: data.music
                        )
                    }

                case .failure(let error):
                    print(" 음악 정보 API 오류: \(error)")
                }
            }
        }

    private func setupActions() {
        // 하단 메뉴의 각각의 라벨에 제스처 추가
        guard let bottomMenuSubviews = musicLoadView.bottomMenuStackView.arrangedSubviews as? [UILabel] else {
            return
        }
        // 재생 버튼 누를 시에 음악 재생
        musicLoadView.playPauseButton.addTarget(self, action: #selector(playPauseMusic), for: .touchUpInside)
          

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
    }
    
    // 뒤로 가기 액션
    @objc private func popButton() {
        self.dismiss(animated: true)
    }

    // 다음 트랙 화면으로 이동
    @objc private func goToNextTrack() {
        let nextTrackVC = MusicSegmentVC()
        present(nextTrackVC, animated: true)
    }

    // 가사 화면으로 이동
    @objc private func goToLyrics() {
        let lyricsVC = LyricsVC()
        self.navigationController?.pushViewController(lyricsVC, animated: true)
    }

    // 추천 콘텐츠 화면으로 이동
    @objc private func goToRecommend() {
        let recommendVC = RecommendVC()
        self.navigationController?.pushViewController(recommendVC, animated: true)
    }
    // 재생 버튼 누를 시에 음악 재생하기
    @objc private func playPauseMusic() {
            guard let musicUrlString = musicInfo?.music, let url = URL(string: musicUrlString) else {
                print("❌ 음악 URL이 유효하지 않습니다.")
                return
            }

            if player == nil {
                player = AVPlayer(url: url)
            }

            if player?.timeControlStatus == .playing {
                player?.pause()
                musicLoadView.updatePlayButton(isPlaying: false)
            } else {
                player?.play()
                musicLoadView.updatePlayButton(isPlaying: true)
            }
        }
    
}
