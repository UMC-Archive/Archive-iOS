import UIKit
import Foundation

class ProfileSelectVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private let profileSelectView = ProfileSelectView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .black
        
        view.addSubview(profileSelectView)
        profileSelectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        setupActions()
        updateCompleteButtonState() // 초기 상태 업데이트
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateCompleteButtonState() // 화면 돌아올 때 상태 업데이트
    }
    
    private func setupActions() {
        profileSelectView.onProfileImageTapped = { [weak self] in
            self?.showImagePicker()
        }
        profileSelectView.leftArrowButton.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)
        profileSelectView.profileName.addTarget(self, action: #selector(nicknameEditingChanged), for: .editingChanged)
        profileSelectView.completeButton.addTarget(self, action: #selector(handleNext), for: .touchUpInside)
    }
    
    @objc private func leftButtonTapped() {
        print("눌림!")
        let moveVC = Register2VC()
        navigationController?.pushViewController(moveVC, animated: true)
    }
    
    @objc private func nicknameEditingChanged() {
        updateCompleteButtonState()
    }
    
    private func updateCompleteButtonState() {
        profileSelectView.completeButton.isEnabled = true
        let isNicknameEntered = !(profileSelectView.profileName.text?.isEmpty ?? true)
        let isImageSelected = profileSelectView.profileImage.image != UIImage(named: "profileSample")
        
        let isEnabled = isNicknameEntered && isImageSelected
        
      
    }
    
    private func showImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            profileSelectView.profileImage.image = selectedImage
            UserSignupData.shared.profileImage = selectedImage
        }
        dismiss(animated: true) {
            self.updateCompleteButtonState()
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    @objc private func handleNext() {
        let nickname = profileSelectView.profileName.text
          let isNicknameEntered = !(nickname?.isEmpty ?? true)
          let isImageSelected = profileSelectView.profileImage.image != UIImage(named: "profileSample")

          if !isNicknameEntered {
              showAlert(message: "프로필 이름을 입력해주세요.")
              return
          }

          if !isImageSelected {
              showAlert(message: "프로필 사진을 선택해주세요.")
              return
          }
        // 닉네임 저장
        UserSignupData.shared.nickname = profileSelectView.profileName.text ?? ""
        let preferGenreVC = PreferGenreVC()
        navigationController?.pushViewController(preferGenreVC, animated: true)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}

