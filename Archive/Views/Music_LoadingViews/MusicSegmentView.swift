import UIKit

class MusicSegmentView: UIView {

    let albumInfoView = AlbumInfoView()

    let tabBar: UISegmentedControl = {
        let items = ["다음 트랙", "가사", "추천 콘텐츠"]
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.backgroundColor = .black
        segmentedControl.selectedSegmentTintColor = .clear
        
        segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.white, .font: UIFont.boldSystemFont(ofSize: 16)], for: .selected)
        segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.gray, .font: UIFont.systemFont(ofSize: 16)], for: .normal)

        segmentedControl.setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
        segmentedControl.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        return segmentedControl
    }()

    let nextTrackCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 60)
        layout.minimumLineSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .black
        return collectionView
    }()

    let lyricsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 40)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .black
        return collectionView
    }()
    private lazy var normalUnderbar = UIView().then{
        $0.backgroundColor = UIColor.white.withAlphaComponent(0.7)
    }
    lazy var selectedUnderbar: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()


    let recommendContentView = UIView()

    let albumCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 60)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .black
        return collectionView
    }()

    let albumRecommendCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 140, height: 186)
        layout.minimumLineSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .black
        return collectionView
    }()

    let recommendTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "당신을 위한 앨범 추천"
        label.font = .customFont(font: .SFPro, ofSize: 21, rawValue: 700)
        label.textColor = .white
        return label
    }()
    let rightButton : UIButton = {
        let button = UIButton()
        button.setImage( UIImage(named: "right"), for: .normal)
        button.contentMode = .scaleAspectFit
        button.isUserInteractionEnabled = true
        return button
        
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
        addSubview(albumInfoView)
        addSubview(tabBar)
        addSubview(selectedUnderbar)
        addSubview(normalUnderbar)

        addSubview(nextTrackCollectionView)
        addSubview(lyricsCollectionView)
        addSubview(recommendContentView)

        recommendContentView.addSubview(recommendTitleLabel)
        recommendContentView.addSubview(albumCollectionView)
        recommendContentView.addSubview(albumRecommendCollectionView)
        recommendContentView.addSubview(rightButton)
    }

    private func setupConstraints() {
        albumInfoView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(10)
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(70)
        }

        tabBar.snp.makeConstraints { make in
            make.top.equalTo(albumInfoView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
        }
        normalUnderbar.snp.makeConstraints{
            $0.top.equalTo(tabBar.snp.bottom).offset(1 * UIScreen.main.screenHeight / 667) // 667는 미니 화면 높이
            $0.leading.equalTo(tabBar.snp.leading)
            $0.width.equalTo(tabBar.snp.width)
            $0.height.equalTo(0.5)
        }
        selectedUnderbar.snp.makeConstraints {
            $0.bottom.equalTo(normalUnderbar.snp.bottom)
            $0.leading.equalTo(tabBar.snp.leading)
            $0.width.equalTo(67)
            $0.height.equalTo(1)
        }

        nextTrackCollectionView.snp.makeConstraints { make in
            make.top.equalTo(tabBar.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview()
        }

        lyricsCollectionView.snp.makeConstraints { make in
            make.edges.equalTo(nextTrackCollectionView)
        }

        recommendContentView.snp.makeConstraints { make in
            make.edges.equalTo(nextTrackCollectionView)
        }
        
        albumCollectionView.snp.makeConstraints { make in
            make.top.equalTo(tabBar.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(300)
        }
        recommendTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(albumCollectionView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(10)
        }
        
        rightButton.snp.makeConstraints { make in
            make.top.equalTo(albumCollectionView.snp.bottom).offset(20)
            make.centerY.equalTo(recommendTitleLabel)
            make.leading.equalTo(recommendTitleLabel.snp.trailing).offset(146)
        }
       

        albumRecommendCollectionView.snp.makeConstraints { make in
            make.top.equalTo(recommendTitleLabel.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(200)
        }
    }
}

