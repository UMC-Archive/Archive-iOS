//
//  UserSignUpData.swift
//  Archive
//
//  Created by 손현빈 on 2/1/25.
//
import UIKit

struct UserSignupData {
    static var shared = UserSignupData()

    var email: String?  // 이메일
    var password: String? // 비밀번호 
    var nickname: String?
    var profileImage: UIImage?
    var selectedArtists: [Int] = []
    var selectedGenres: [Int] = []

    mutating func reset() {
        email = nil
        password = nil
        nickname = nil
        profileImage = nil
        selectedArtists = []
        selectedGenres = []
    }
}
