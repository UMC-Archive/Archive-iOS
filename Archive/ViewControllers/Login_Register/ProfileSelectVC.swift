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
        updateCompleteButtonState()
        profileSelectView.completeButton.isEnabled = true

    }
    @objc private func leftButtonTapped(){
        print("눌림!")
        let moveVC = Register2VC()
        navigationController?.pushViewController(moveVC,animated: true)
        
       
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
            profileSelectView.completeButton.isEnabled = true
             
             // 버튼 색상 변경만 처리 (원하는 스타일이면 사용, 아니면 생략해도 됨)
             let isNicknameEntered = !(profileSelectView.profileName.text?.isEmpty ?? true)
             let isImageSelected = profileSelectView.profileImage.image != UIImage(named: "profileSample")

             let isEnabled = isNicknameEntered && isImageSelected
             profileSelectView.updateNextButtonState(isEnabled: isEnabled)

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
            // 닉네임 텍스트 필드 저장
            UserSignupData.shared.nickname = profileSelectView.profileName.text ?? ""
            print("닉네임 있음 -> 다음 화면")
            let preferGenreVC = PreferGenreVC() // 다음 화면
            navigationController?.pushViewController(preferGenreVC, animated: true)
        }
        private func showAlert(message: String) {
            let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    

