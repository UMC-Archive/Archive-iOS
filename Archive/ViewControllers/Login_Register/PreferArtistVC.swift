import UIKit
import SnapKit

class PreferArtistVC: UIViewController {
    private let userService = UserService()
    private let preferArtistView = PreferArtistView()
    private var selectedArtists: [String] = [] // 선택된 아티스트 목록
    private var allArtists = [
        "Black Pink", "Rose", "NewJeans", "Kiss of life", "aespa", "TWS", "TXT", "BTS",
        "Aimyon", "실리카겔", "요루시카", "요네즈 켄시", "Selena Gomez", "BTOB", "제로베이스원", "Taylor Swift"
    ] // 전체 아티스트 목록

    override func loadView() {
        self.view = preferArtistView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupActions()
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
        print("Selected Artists: \(selectedArtists)")
        // 다음 화면 전환 여기를 로그인으로
        
        UserSignupData.shared.selectedArtists = selectedArtists
        // 하고 여기서 회원가입이 끝나니까 회원가입 끝나고 회원가입 API 가 시작해야한다.
        // 회원가입 API
        
        // 날짜 정하기
        let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "yyyy-MM-dd"
           let todayDate = dateFormatter.string(from: Date())
        
        let profileImage = UserSignupData.shared.profileImage ?? UIImage(named: "default_profile")!

           // 회원가입 요청 데이터 생성
           let signUpData = SignUpRequestDTO(
               nickname: UserSignupData.shared.nickname ?? "", // 저장된 닉네임
               email: UserSignupData.shared.email ?? "", // 저장된 이메일
               password: UserSignupData.shared.password ?? "", // 저장된 비밀번호
               status: "active",
               socialType: "local",
               inactiveDate: todayDate,
               artists: UserSignupData.shared.selectedArtists.map { $0 },
               genres: UserSignupData.shared.selectedGenres.map { $0}
           )

           // 회원가입 API 호출
        userService.signUp(image: profileImage, parameter: signUpData) { [weak self] result in
               guard let self = self else { return }
               DispatchQueue.main.async {
                   switch result {
                   case .success:
                       print("회원가입 성공 ")
                       // 로그인 화면으로 이동
                       let loginVC = LoginVC()
                       self.navigationController?.setViewControllers([loginVC], animated: true)
                   case .failure(let error):
                       print("회원가입 실패 : \(error.localizedDescription)")
                   }
               }
           }
        
        
        let loginVC = LoginVC()
        navigationController?.pushViewController(loginVC, animated: true)
    }
}
extension PreferArtistVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedArtists.count + allArtists.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ArtistCell.identifier, for: indexPath) as? ArtistCell else {
            fatalError("Unable to dequeue ArtistCell")
        }

        let artistName: String
        let isSelected: Bool

        if indexPath.row < selectedArtists.count {
            artistName = selectedArtists[indexPath.row]
            isSelected = true
        } else {
            artistName = allArtists[indexPath.row - selectedArtists.count]
            isSelected = false
        }

        cell.configure(imageName: artistName, name: artistName, isSelected: isSelected)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let artistName: String

        if indexPath.row < selectedArtists.count {
            artistName = selectedArtists[indexPath.row]
        } else {
            artistName = allArtists.remove(at: indexPath.row - selectedArtists.count)
            selectedArtists.append(artistName)
        }
        

        collectionView.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if indexPath.row < selectedArtists.count {
            let artistName = selectedArtists.remove(at: indexPath.row)
            allArtists.insert(artistName, at: 0)
            collectionView.reloadData()
        }
    }
}
class ArtistCell: UICollectionViewCell {
    static let identifier = "ArtistCell"

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

    func configure(imageName: String, name: String, isSelected: Bool) {
        artistImageView.image = UIImage(named: imageName)
        artistNameLabel.text = name

        // 선택되지 않은 상태에서는 어두운 오버레이를 보이게
        overlayView.isHidden = isSelected
    }
}
