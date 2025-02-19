//
//  ProfileSelectVC.swift
//  Archive
//
//  Created by 손현빈 on 1/26/25.
//

import UIKit
import Foundation

class ProfileSelectVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private let profileSelectView = ProfileSelectView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
        // 배경색 설정
        view.backgroundColor = .black
        
        // ProfileSelectView 추가
        view.addSubview(profileSelectView)
        
        // Auto Layout 설정
        profileSelectView.snp.makeConstraints { make in
            make.edges.equalToSuperview() // 부모 뷰의 모든 가장자리에 맞춤
        }
        
        setupActions()
    }
    @objc private func leftButtonTapped(){
        print("눌림!")
        let moveVC = Register2VC()
        navigationController?.pushViewController(moveVC,animated: true)
    }
        
        override func viewWillAppear(_ animated: Bool){
            super.viewWillAppear(animated)
        }
    
        private func setupActions() {
            // 프로필 이미지 선택 이벤트
            profileSelectView.onProfileImageTapped = { [weak self] in
                self?.showImagePicker()
            }
            profileSelectView.leftArrowButton.addTarget(self,action: #selector(leftButtonTapped),for: .touchUpInside)
            profileSelectView.profileName.addTarget(self, action: #selector(nicknameEditingChanged), for: .editingChanged)
            
            // 완료 버튼 액션
            profileSelectView.completeButton.addTarget(self, action: #selector(handleNext), for: .touchUpInside)
        }
        
        
        private func updateCompleteButtonState() {
            let isNicknameEntered = !(profileSelectView.profileName.text?.isEmpty ?? true)
            let isImageSelected = profileSelectView.profileImage.image != UIImage(named: "profileSample")
            
            // 두 개 다 만족해야 버튼이 활성화됨
            let isEnabled = isNicknameEntered && isImageSelected
            
            DispatchQueue.main.async {
                self.profileSelectView.completeButton.isEnabled = isEnabled
                self.profileSelectView.updateNextButtonState(isEnabled: isEnabled)
            }
        }
        
        @objc private func nicknameEditingChanged() {
            let isNicknameEntered = !(profileSelectView.profileName.text?.isEmpty ?? true)
            let isImageSelected = profileSelectView.profileImage.image != UIImage(named: "profileSample")
            
            if isNicknameEntered && isImageSelected {
                updateCompleteButtonState()
            }
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
            

            guard let nickname = profileSelectView.profileName.text, !nickname.isEmpty else {
                showAlert(message: "프로필 이름을 입력해주세요.")
                return
            }
            
            if let defaultImage = UIImage(named: "profileSample"),
               let currentImageData = profileSelectView.profileImage.image?.pngData(),
               let defaultImageData = defaultImage.pngData(),
               currentImageData == defaultImageData {
                showAlert(message: "프로필 이미지를 선택해주세요.")
                return
            }
            
            
            // 닉네임 텍스트 필드 저장
            UserSignupData.shared.nickname = profileSelectView.profileName.text ?? ""
            
            let preferGenreVC = PreferGenreVC() // 다음 화면
            navigationController?.pushViewController(preferGenreVC, animated: true)
        }

        private func showAlert(message: String) {
            let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true)
        }
    
}
