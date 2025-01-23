//
//  Untitled.swift
//  Archive
//
//  Created by 송재곤 on 1/16/25.
//

import UIKit

struct RecapModel {
    let CDImage : UIImage
}

extension RecapModel {
    static func dummy() -> [RecapModel]{
        return [//구분을 위해 빨강 추가
            RecapModel(CDImage: .test1),
            RecapModel(CDImage: .cdSample),
            RecapModel(CDImage: .cdSample),
            
        ]
    }
}
