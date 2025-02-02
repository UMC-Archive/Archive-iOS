import UIKit

class PreferArtistVC: UIViewController {
    private let preferArtistView = PreferArtistView()
    private let userService = UserService() // 회원가입을 위한 유저 서비스 추가
    private var selectedArtists: [ArtistInfoReponseDTO] = [] // 선택된 아티스트 목록
    private var allArtists: [ArtistInfoReponseDTO] = [] // 서버에서 받아온 아티스트 목록
    private let musicService = MusicService() // 음악 서비스 추가

    override func loadView() {
        self.view = preferArtistView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupActions()
        fetchArtists()
    }

    //  서버에서 아티스트 목록 가져오기
    private func fetchArtists() {
        musicService.chooseArtistInfo { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    if let artists = response?.artists {
                        self.allArtists = artists
                        self.preferArtistView.ArtistCollectionView.reloadData()
                    }
                case .failure(let error):
                    print(" 아티스트 정보를 불러오는데 실패했습니다: \(error)")
                }
            }
        }
    }

    // UICollectionView 설정
    private func setupCollectionView() {
        preferArtistView.ArtistCollectionView.delegate = self
        preferArtistView.ArtistCollectionView.dataSource = self
        preferArtistView.ArtistCollectionView.register(ArtistCell.self, forCellWithReuseIdentifier: ArtistCell.identifier)
        preferArtistView.ArtistCollectionView.allowsMultipleSelection = true
    }

    // 버튼 액션 설정
    private func setupActions() {
        preferArtistView.nextButton.addTarget(self, action: #selector(handleNext), for: .touchUpInside)
    }

    @objc private func handleNext() {
        print("Selected Artists: \(selectedArtists.map { $0.name })")
        UserSignupData.shared.selectedArtists = selectedArtists.compactMap { Int($0.id)} // ID만 저장
        // 회원가입 API
        postSignUp()
        //  회원가입 완료 후 로그인 화면으로 이동
        let loginVC = LoginVC()
        navigationController?.pushViewController(loginVC, animated: true)
    }
    private func postSignUp(){
        // 1. 오늘 날짜 포맷 지정 (YYYY-MM-DD)
               let dateFormatter = DateFormatter()
               dateFormatter.dateFormat = "yyyy-MM-dd"
               let todayDate = dateFormatter.string(from: Date())

               // 2. 기본 프로필 이미지 설정 (없으면 기본 이미지)
               let profileImage = UserSignupData.shared.profileImage ?? UIImage(named: "default_profile")!

               // 3. 회원가입 요청 데이터 생성
               let signUpData = SignUpRequestDTO(
                   nickname: UserSignupData.shared.nickname ?? "",
                   email: UserSignupData.shared.email ?? "",
                   password: UserSignupData.shared.password ?? "",
                   status: "active",
                   socialType: "local",
                   inactiveDate: todayDate,
                   artists: UserSignupData.shared.selectedArtists,
                   genres: UserSignupData.shared.selectedGenres
               )

               // 4. API 호출
               userService.signUp(image: profileImage, parameter: signUpData) { [weak self] result in
                   guard let self = self else { return }
                   DispatchQueue.main.async {
                       switch result {
                       case .success:
                           print(" 회원가입 성공!")
                           
                           // 5. 회원가입 성공 시 로그인 화면으로 이동
                           let loginVC = LoginVC()
                           self.navigationController?.setViewControllers([loginVC], animated: true)

                       case .failure(let error):
                           print(" 회원가입 실패: \(error.localizedDescription)")

                           // 6. 실패 시 사용자에게 얼럿 표시
                           let alert = UIAlertController(title: "회원가입 실패", message: error.localizedDescription, preferredStyle: .alert)
                           alert.addAction(UIAlertAction(title: "확인", style: .default))
                           self.present(alert, animated: true)
                       }
                   }
               }
           }



}
// MARK: - UICollectionViewDelegate & UICollectionViewDataSource
extension PreferArtistVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedArtists.count + allArtists.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ArtistCell.identifier, for: indexPath) as? ArtistCell else {
            fatalError("Unable to dequeue ArtistCell")
        }

        let artist: ArtistInfoReponseDTO
        let isSelected: Bool

        if indexPath.row < selectedArtists.count {
            artist = selectedArtists[indexPath.row]
            isSelected = true
        } else {
            artist = allArtists[indexPath.row - selectedArtists.count]
            isSelected = false
        }

        cell.configure(imageURL: artist.image, name: artist.name, isSelected: isSelected)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row >= selectedArtists.count {
            let artist = allArtists.remove(at: indexPath.row - selectedArtists.count)
            selectedArtists.insert(artist, at: 0)
            collectionView.reloadData()
        }
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if indexPath.row < selectedArtists.count {
            let artist = selectedArtists.remove(at: indexPath.row)
            allArtists.insert(artist, at: 0)
            collectionView.reloadData()
        }
    }
}

class ArtistCell: UICollectionViewCell {
    static let identifier = "ArtistCell"
    private static var imageCache = NSCache<NSString, UIImage>() // 이미지 캐시

    private var artistImageView = UIImageView().then { make in
        make.contentMode = .scaleAspectFill
        make.layer.cornerRadius = 50
        make.clipsToBounds = true
    }

    private var artistNameLabel = UILabel().then { make in
        make.font = UIFont.systemFont(ofSize: 12)
        make.textColor = .white
        make.textAlignment = .center
    }

    private var overlayView = UIView().then { make in
        make.backgroundColor = UIColor(white: 0, alpha: 0.4) // 어둡게 보이는 오버레이
        make.isHidden = true // 기본적으로 숨김
        make.layer.cornerRadius = 50
        make.clipsToBounds = true
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        contentView.addSubview(artistImageView)
        contentView.addSubview(overlayView) // 오버레이 추가
        contentView.addSubview(artistNameLabel)
    }

    private func setupConstraints() {
        artistImageView.translatesAutoresizingMaskIntoConstraints = false
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        artistNameLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            artistImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            artistImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            artistImageView.widthAnchor.constraint(equalToConstant: 100),
            artistImageView.heightAnchor.constraint(equalToConstant: 100),

            overlayView.topAnchor.constraint(equalTo: artistImageView.topAnchor),
            overlayView.leadingAnchor.constraint(equalTo: artistImageView.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: artistImageView.trailingAnchor),
            overlayView.bottomAnchor.constraint(equalTo: artistImageView.bottomAnchor),

            artistNameLabel.topAnchor.constraint(equalTo: artistImageView.bottomAnchor, constant: 5),
            artistNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            artistNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }

    func configure(imageURL: String, name: String, isSelected: Bool) {
        artistNameLabel.text = name
        overlayView.isHidden = isSelected

        if let cachedImage = ArtistCell.imageCache.object(forKey: imageURL as NSString) {
            //  캐시된 이미지가 있으면 사용
            artistImageView.image = cachedImage
        } else {
            // 캐시된 이미지가 없으면 URL에서 다운로드
            downloadImage(from: imageURL)
        }
    }

    private func downloadImage(from urlString: String) {
        guard let url = URL(string: urlString) else {
            print(" 잘못된 이미지 URL: \(urlString)")
            return
        }

        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self, let data = data, error == nil, let image = UIImage(data: data) else {
                print("이미지 다운로드 실패: \(error?.localizedDescription ?? "알 수 없는 오류")")
                return
            }

            //  이미지 캐시에 저장
            ArtistCell.imageCache.setObject(image, forKey: urlString as NSString)

            DispatchQueue.main.async {
                self.artistImageView.image = image
            }
        }
        task.resume()
    }
}

