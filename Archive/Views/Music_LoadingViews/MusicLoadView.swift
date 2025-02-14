
import UIKit
import SnapKit
import Then
import Kingfisher

class MusicLoadView: UIView {
    
    // popButton
    public let popButton = UIButton().then { button in
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "chevron.down")
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        config.imagePadding = 0
        button.configuration = config
        button.tintColor = .white
    }

    // 앨범 이미지
    lazy var albumImageView = UIImageView().then { make in
        make.contentMode = .scaleAspectFill
        make.layer.cornerRadius = 10
        make.clipsToBounds = true
        make.layer.borderWidth = 2
        make.layer.borderColor = UIColor.blue.cgColor
    }

    // 곡 제목
    lazy var titleLabel = UILabel().then { make in
        make.text = "Supernatural"
        make.textColor = .white
        make.font = UIFont.boldSystemFont(ofSize: 24)
        make.textAlignment = .left
    }

    // 제목 옆 아이콘
    lazy var titleIcon = UIImageView().then { make in
        make.image = UIImage(systemName: "rectangle.on.rectangle")
        make.tintColor = .white
        make.contentMode = .scaleAspectFit
    }

    // 아티스트 이름
    lazy var artistLabel = UILabel().then { make in
        make.text = "NewJeans"
        make.textColor = .gray
        make.font = UIFont.systemFont(ofSize: 16)
        make.textAlignment = .left
    }

    // 제목과 아티스트를 묶는 스택뷰 (수직)
    lazy var titleArtistStackView = UIStackView().then { stackView in
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .leading
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(artistLabel)
    }

    // 앨범 이미지와 제목/아티스트를 묶는 스택뷰 (수평)
    lazy var albumInfoStackView = UIStackView().then { stackView in
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.alignment = .center
        stackView.addArrangedSubview(titleArtistStackView)
        stackView.addArrangedSubview(titleIcon)
    }

    // 재생 슬라이더
    lazy var progressSlider = UISlider().then { slider in
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.value = 0.23
        slider.minimumTrackTintColor = .white
        slider.maximumTrackTintColor = .gray
        slider.thumbTintColor = .white
    }

    // 재생 시간 레이블
    lazy var currentTimeLabel = UILabel().then { make in
        make.text = "0:00"
        make.textColor = .gray
        make.font = UIFont.systemFont(ofSize: 12)
    }

    lazy var totalTimeLabel = UILabel().then { make in
        make.text = "0:30"
        make.textColor = .gray
        make.font = UIFont.systemFont(ofSize: 12)
    }

    // 재생 제어 버튼들
    lazy var repeatButton = UIButton().then { button in
        button.setImage(UIImage(systemName: "repeat"), for: .normal)
        button.tintColor = .white
    }

    lazy var previousButton = UIButton().then { button in
        button.setImage(UIImage(systemName: "backward.fill"), for: .normal)
        button.tintColor = .white
    }

    lazy var playPauseButton = UIButton().then { button in
        button.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 25
        button.backgroundColor = .black
    }

    lazy var nextButton = UIButton().then { button in
        button.setImage(UIImage(systemName: "forward.fill"), for: .normal)
        button.tintColor = .white
    }

    lazy var shuffleButton = UIButton().then { button in
        button.setImage(UIImage(systemName: "shuffle"), for: .normal)
        button.tintColor = .white
    }

    // 하단 메뉴
    lazy var bottomMenuStackView = UIStackView().then { stackView in
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 20
        stackView.addArrangedSubview(createMenuLabel("다음 트랙"))
        stackView.addArrangedSubview(createMenuLabel("가사"))
        stackView.addArrangedSubview(createMenuLabel("추천 콘텐츠"))
    }

    // 하단 메뉴 라벨 생성 함수
    private func createMenuLabel(_ text: String) -> UILabel {
        return UILabel().then { make in
            make.text = text
            make.textColor = .white
            make.font = UIFont.systemFont(ofSize: 14)
            make.textAlignment = .center
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .black_100
        setupViews()
        setupConstraints()
    }

    private func setupViews() {
        addSubview(popButton)
        addSubview(albumImageView)
        addSubview(albumInfoStackView)
        addSubview(progressSlider)
        addSubview(currentTimeLabel)
        addSubview(totalTimeLabel)
        addSubview(repeatButton)
        addSubview(previousButton)
        addSubview(playPauseButton)
        addSubview(nextButton)
        addSubview(shuffleButton)
        addSubview(bottomMenuStackView)
    }

    private func setupConstraints() {
        // 뒤로 가기 버튼
        popButton.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(15)
            make.trailing.equalToSuperview().inset(40)
            make.width.height.equalTo(30)
        }
        
        // 앨범 이미지
        albumImageView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(91)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(300)
        }

        // 앨범 정보 스택뷰
        albumInfoStackView.snp.makeConstraints { make in
            make.top.equalTo(albumImageView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(50) // 약간 뒤로 이동
            make.trailing.equalToSuperview().offset(-20)
        }

        // 제목 옆 아이콘
        titleIcon.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            make.trailing.equalTo(albumImageView.snp.trailing).offset(10) // 살짝 앞으로 이동
        }

        // 슬라이더
        progressSlider.snp.makeConstraints { make in
            make.top.equalTo(albumInfoStackView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }

        // 재생 시간 레이블
        currentTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(progressSlider.snp.bottom).offset(8)
            make.leading.equalTo(progressSlider)
        }

        totalTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(progressSlider.snp.bottom).offset(8)
            make.trailing.equalTo(progressSlider)
        }

        // 재생 버튼들
        playPauseButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(currentTimeLabel.snp.bottom).offset(20)
            make.width.height.equalTo(50)
        }

        previousButton.snp.makeConstraints { make in
            make.centerY.equalTo(playPauseButton)
            make.trailing.equalTo(playPauseButton.snp.leading).offset(-30)
        }

        nextButton.snp.makeConstraints { make in
            make.centerY.equalTo(playPauseButton)
            make.leading.equalTo(playPauseButton.snp.trailing).offset(30)
        }

        repeatButton.snp.makeConstraints { make in
            make.centerY.equalTo(playPauseButton)
            make.trailing.equalTo(previousButton.snp.leading).offset(-30)
        }

        shuffleButton.snp.makeConstraints { make in
            make.centerY.equalTo(playPauseButton)
            make.leading.equalTo(nextButton.snp.trailing).offset(30)
        }

        // 하단 메뉴
        bottomMenuStackView.snp.makeConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-20)
            make.centerX.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // UI 업데이트 함수
      func updateUI(imageUrl: String, title: String, artist: String, musicUrl: String) {
          albumImageView.kf.setImage(with: URL(string: imageUrl), placeholder: UIImage(named: "placeholder"))
          titleLabel.text = title
          artistLabel.text = artist
      }

      // 재생 버튼 UI 업데이트
      func updatePlayButton(isPlaying: Bool) {
          let buttonImage = isPlaying ? UIImage(systemName: "pause.fill") : UIImage(systemName: "play.fill")
          playPauseButton.setImage(buttonImage, for: .normal)
      }
}

