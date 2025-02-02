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

    private func setupActions() {
        // 프로필 이미지 선택 이벤트
        profileSelectView.onProfileImageTapped = { [weak self] in
            self?.showImagePicker()
        }

        // 완료 버튼 액션
        profileSelectView.completeButton.addTarget(self, action: #selector(handleNext), for: .touchUpInside)
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
        dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
       
        
dismiss(animated: true)
        
        
    }

    @objc private func handleNext() {
        // 닉네임 텍스트 필드 저장
        UserSignupData.shared.nickname = profileSelectView.profileName.text ?? ""

        let preferGenreVC = PreferGenreVC() // 다음 화면
        navigationController?.pushViewController(preferGenreVC, animated: true)
    }
}

