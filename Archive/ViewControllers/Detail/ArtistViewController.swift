//
//  ArtistViewController.swift
//  Archive
//
//  Created by 이수현 on 1/19/25.
//

import UIKit

class ArtistViewController: UIViewController {
    private let artistView = ArtistView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = artistView
    }
}
