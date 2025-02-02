//
//  MusicLoadVC.swift
//  Archive
//
//  Created by 손현빈 on 1/30/25.
//

import UIKit

class MusicLoadVC: UIViewController {

    private let musicLoadView = MusicLoadView()

    override func loadView() {
        self.view = musicLoadView // MusicLoadView를 메인 뷰로 설정
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
    }

    private func setupActions() {
        // 하단 메뉴의 각각의 라벨에 제스처 추가
        guard let bottomMenuSubviews = musicLoadView.bottomMenuStackView.arrangedSubviews as? [UILabel] else {
            return
        }

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
    }

    // 다음 트랙 화면으로 이동
    @objc private func goToNextTrack() {
        let nextTrackVC = NextTrackVC()
        self.navigationController?.pushViewController(nextTrackVC, animated: true)
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
}
