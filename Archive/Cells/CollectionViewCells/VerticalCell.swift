//
//  VerticalCell.swift
//  Archive
//
//  Created by 이수현 on 1/14/25.
//

import UIKit

class VerticalCell: UICollectionViewCell {
    static let id = "VerticalCell"
    
    // 음악 재생 뷰
    public let playMusicView = UIView().then { view in
        view.isUserInteractionEnabled = true
    }
    
    // 앨범 이미지 뷰
    public let imageView = AlbumImageView()
    
    // Album & SongTitle
    private let titleLabel = UILabel().then { lbl in
        lbl.font = .customFont(font: .SFPro, ofSize: 18, rawValue: 400)
        lbl.textColor = .white
        lbl.numberOfLines = 1
    }
    
    // 아티스트 ⦁ year
    public let artistYearLabel = UILabel().then { lbl in
        lbl.font = .customFont(font: .SFPro, ofSize: 13, rawValue: 400)
        lbl.textColor = .white_70
        lbl.numberOfLines = 1
        lbl.isUserInteractionEnabled = true
        lbl.sizeToFit()
    }
    
    // 더보기 버튼
    public let overflowButton = OverflowButton()
    
    // 더보기 뷰
    public let overflowView = OverflowView().then { view in
        view.isHidden = true
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setSubView()
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
        titleLabel.text = nil
        artistYearLabel.text = nil
        overflowButton.removeTarget(nil, action: nil, for: .allEvents)
        
        gestureRecognizers = nil
    }
    
    private func setSubView() {
        [
            imageView,
            titleLabel,
            playMusicView,
            artistYearLabel,
            overflowButton,
            overflowView
        ].forEach{self.addSubview($0)}
    }
    
    private func setUI(){
        // 이미지 뷰
        imageView.snp.makeConstraints { make in
            make.centerY.leading.equalToSuperview()
            make.width.height.equalTo(50)
            make.bottom.equalToSuperview().priority(.low)
        }
        
        // 타이틀
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView).offset(6)
            make.leading.equalTo(imageView.snp.trailing).offset(10)
            make.trailing.equalTo(overflowButton.snp.leading).offset(-10)
        }
        
        // 해당 뷰 탭에 따라 음악 재생
        playMusicView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalTo(titleLabel)
        }
        
        // 아티스트
        artistYearLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(2)
            make.leading.equalTo(titleLabel)
//            make.trailing.equalTo(overflowButton.snp.leading)
        }
        
        // 더보기 버튼
        overflowButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(8)
            make.width.equalTo(10)
            make.height.equalTo(17)
        }
        
        // 더보기 뷰
        overflowView.snp.makeConstraints { make in
            make.width.equalTo(97)
            make.height.equalTo(52.5)
//            make.top.equalTo(overflowButton.snp.bottom).offset(7.5)
            make.centerY.equalToSuperview()
            make.trailing.equalTo(overflowButton).offset(-7)
        }
    }
    
    // 숨겨진 명곡
    public func configHiddenMusic(music: HiddenMusicResponse, artist: String){
        imageView.kf.setImage(with: URL(string: music.image))
        titleLabel.text = music.title
        artistYearLabel.text = "\(artist) ⦁ \(music.releaseTime.prefixBeforeDash())"
    }
    
    // 탐색 뷰 - 추천곡
    public func configExploreRecommendMusic(music: ExploreRecommendMusic, artist: String){
        imageView.kf.setImage(with: URL(string: music.image))
        titleLabel.text = music.title
        artistYearLabel.text = "\(artist) ⦁ \(music.releaseTime.prefixBeforeDash())"
    }
    
    // 홈 - 추천곡
    public func configHomeRecommendMusic(music: RecommendMusic, artist: String){
        imageView.kf.setImage(with: URL(string: music.image))
        titleLabel.text = music.title
        artistYearLabel.text = "\(artist) ⦁ \(music.releaseTime.prefixBeforeDash())"
    }
    
    // 홈 - 최근에 추가한 노래
    public func configRecentlyAddMusic(music: RecentMusicDTO, artist: String) {
        imageView.kf.setImage(with: URL(string: music.image))
        titleLabel.text = music.title
        artistYearLabel.text = "\(artist) ⦁ \(music.releaseTime.prefixBeforeDash())"
    }
    
    // 트랙 리스트
    public func configTrackList(music: TrackListResponse){
        imageView.kf.setImage(with: URL(string: music.image))
        titleLabel.text = music.title
        artistYearLabel.text = "\(music.artist) ⦁ \(music.releaseTime)"
    }
    
    // 아티스트 인기곡
    public func configPopularMusic(music: MusicInfoResponseDTO, artist: String) {
        imageView.kf.setImage(with: URL(string: music.image))
        titleLabel.text = music.title
        artistYearLabel.text = "\(artist) ⦁ \(music.releaseTime.prefixBeforeDash())"
    }
    
    public func setOverflowView(type: OverflowType){
        overflowView.setType(type: type)
        switch type {
        case .inAlbum:
            overflowView.snp.updateConstraints { make in
                make.height.equalTo(26)
            }
        default:
            return
        }
    }
}
