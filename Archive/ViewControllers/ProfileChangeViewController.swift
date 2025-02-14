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
    private let nickName: ProfileChangePostRequestDTO? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = rootView
        
        controlTapped()
        setupActions()
    }
    private func controlTapped() {
        rootView.navigationView.popButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        rootView.button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        let profileChangeGesture = UITapGestureRecognizer(target: self, action: #selector(showImagePicker))
        rootView.profileImage.isUserInteractionEnabled = true
        rootView.profileImage.addGestureRecognizer(profileChangeGesture)
    }

    @objc func backButtonTapped(){
        self.navigationController?.popViewController(animated: true)
        print("1")
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
            let requestDTO = ProfileChangePostRequestDTO(nickname: "닉네임")
            
            userService.profileChange(image: selectedImage, parameter: requestDTO) { [weak self] result in
                    guard let self = self else { return }
                    
                    switch result {
                    case .success(let response):
                        print("post profile() 성공")
                        print(response)
                        Task{
                            
                        }
                    case .failure(let error):
                        // 네트워크 연결 실패 얼럿
                        let alert = NetworkAlert.shared.getAlertController(title: error.description)
                        self.present(alert, animated: true)
                }
            }
            
        }
        dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
       
        
dismiss(animated: true)
        
        
    }
}
