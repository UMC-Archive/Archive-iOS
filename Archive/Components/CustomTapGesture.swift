//
//  CustomTapGesture.swift
//  Archive
//
//  Created by 이수현 on 2/1/25.
//

import UIKit

class CustomTapGesture: UITapGestureRecognizer {
    var artist: String? = nil
    var album: String? = nil
    var musicId: String? = nil
    var recapDTO: [RecapResponseDTO]? = nil
}
