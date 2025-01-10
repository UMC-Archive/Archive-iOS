//
//  PlayListDummy.swift
//  Archive
//
//  Created by 송재곤 on 1/9/25.
//

import UIKit

struct PlayListDummy {
    let albumImage: UIImage //collectionView로 변경예정?
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
