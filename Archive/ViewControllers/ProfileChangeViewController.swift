//
//  ProfileChangeViewController.swift
//  Archive
//
//  Created by 송재곤 on 1/21/25.
//

import UIKit

class ProfileChangeViewController : UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let rootView = ProfileChangeView()
    private let userService = UserService()
    private var profileImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = rootView
        
        controlTapped()
        setupActions()
    }
    private func controlTapped() {
        rootView.navigationView.popButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)

        
        let profileChangeGesture = UITapGestureRecognizer(target: self, action: #selector(showImagePicker))
        rootView.profileImage.isUserInteractionEnabled = true
        rootView.profileImage.addGestureRecognizer(profileChangeGesture)
        
        rootView.button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }

    @objc func backButtonTapped(){
        self.navigationController?.popViewController(animated: true)
        print("1")
    }
    @objc func saveButtonTapped(){
        
        if rootView.nicknameLabel.text == "" {
            let alert = ProfileAlert.shared.getAlertController(type: .nickname)
            self.present(alert, animated: true)
            return}
        
        let requestDTO = ProfileChangePostRequestDTO(nickname: rootView.nicknameLabel.text ?? "error")
        userService.profileChange(image: profileImage, parameter: requestDTO) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let response):
                    print("post profile() 성공")
                    print(response)
                    KeychainService.shared.save(account: .userInfo, service: .profileImage, value: response?.profileImage ?? "")
                    KeychainService.shared.save(account: .userInfo, service: .nickname, value: response?.nickname ?? "닉네임")
                    self.navigationController?.popViewController(animated: true)
                case .failure(let error):
                    // 네트워크 연결 실패 얼럿
                    let alert = NetworkAlert.shared.getAlertController(title: error.description)
                    self.present(alert, animated: true)
            }
        }

    }
    private func setupActions() {
        // 프로필 이미지 선택 이벤트
        rootView.onProfileImageTapped = { [weak self] in
            self?.showImagePicker()
            
            
        }
    }

    @objc func showImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            rootView.profileImage.image = selectedImage
            profileImage = selectedImage
    
            
            
        }
        dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
       
        
dismiss(animated: true)
        
        
    }
}
