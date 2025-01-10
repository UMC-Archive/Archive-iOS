//
//  PlayListDummy.swift
//  Archive
//
//  Created by 송재곤 on 1/9/25.
//

import UIKit

struct PlayListDummy {
    let albumImage: UIImage 
}

extension PlayListDummy {
    static func dummy() -> [PlayListDummy]{
        return [
            PlayListDummy(albumImage: UIImage(named: "myPageIcon") ?? UIImage()),
            PlayListDummy(albumImage: UIImage(named: "myPageIcon") ?? UIImage()),
            PlayListDummy(albumImage: UIImage(named: "myPageIcon") ?? UIImage()),
            PlayListDummy(albumImage: UIImage(named: "myPageIcon") ?? UIImage()),
            PlayListDummy(albumImage: UIImage(named: "myPageIcon") ?? UIImage())
        ]
    }
}
