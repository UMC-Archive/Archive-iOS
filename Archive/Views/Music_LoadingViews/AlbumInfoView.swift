import UIKit
import SnapKit

class AlbumInfoView: UIView {
    // 앨범 이미지
    lazy var albumImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        return imageView
    }()

    // 곡 제목 레이블
    lazy var songTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()

    // 아티스트 레이블
    lazy var artistLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()

    // 재생 버튼
    lazy var playButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        
        config.image = UIImage(systemName: "play.fill")
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        button.configuration = config
        button.clipsToBounds = true
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // 겹치는 사각형 아이콘
    lazy var overlappingSquaresView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .playlist
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black_70
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        addSubview(albumImageView)
        addSubview(songTitleLabel)
        addSubview(artistLabel)
        addSubview(playButton)
        addSubview(overlappingSquaresView)
    }

    private func setupConstraints() {
        albumImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(25)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(50)
        }

        songTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(albumImageView).offset(6)
            make.leading.equalTo(albumImageView.snp.trailing).offset(14)
            make.trailing.equalTo(playButton.snp.leading).offset(-40)
        }

        artistLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(14)
            make.leading.equalTo(songTitleLabel)
            make.trailing.equalTo(songTitleLabel)
        }

        playButton.snp.makeConstraints { make in
            make.centerY.equalTo(albumImageView)
            make.trailing.equalTo(overlappingSquaresView.snp.leading).offset(-25)
            make.width.height.equalTo(30)
        }

        overlappingSquaresView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-25)
            make.width.height.equalTo(20)
        }
    }

    // `configure` 메서드로 데이터 설정
    func configure(albumImage: UIImage?, songTitle: String, artistName: String) {
        albumImageView.image = albumImage
        songTitleLabel.text = songTitle
        artistLabel.text = artistName
    }
}

