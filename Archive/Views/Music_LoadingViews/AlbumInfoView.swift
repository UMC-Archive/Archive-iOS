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
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        button.tintColor = .white
        return button
    }()

    // 겹치는 사각형 아이콘
    lazy var overlappingSquaresView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "rectangle.on.rectangle")
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
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
            make.top.leading.equalToSuperview().offset(10)
            make.width.height.equalTo(60)
        }

        songTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(albumImageView.snp.top)
            make.leading.equalTo(albumImageView.snp.trailing).offset(10)
            make.trailing.equalTo(playButton.snp.leading).offset(-10)
        }

        artistLabel.snp.makeConstraints { make in
            make.top.equalTo(songTitleLabel.snp.bottom).offset(5)
            make.leading.equalTo(songTitleLabel)
            make.trailing.equalTo(songTitleLabel)
        }

        playButton.snp.makeConstraints { make in
            make.centerY.equalTo(albumImageView)
            make.trailing.equalToSuperview().offset(-40)
            make.width.height.equalTo(30)
        }

        overlappingSquaresView.snp.makeConstraints { make in
            make.centerY.equalTo(albumImageView)
            make.trailing.equalToSuperview().offset(-10)
            make.width.height.equalTo(30)
        }
    }

    // `configure` 메서드로 데이터 설정
    func configure(albumImage: UIImage?, songTitle: String, artistName: String) {
        albumImageView.image = albumImage
        songTitleLabel.text = songTitle
        artistLabel.text = artistName
    }
}

