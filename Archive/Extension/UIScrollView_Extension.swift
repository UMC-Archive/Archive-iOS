//
//  UIScrollView_Extension.swift
//  Archive
//
//  Created by 이수현 on 1/22/25.
//

import UIKit

extension UIScrollView {
    func getContentHight() -> CGFloat {
        let unionCalculatedTotalRect = recursiveUnionInDepthFor(view: self)

        // 계산된 크기로 컨텐츠 사이즈 설정
//        self.contentSize = CGSize(width: self.frame.width, height: unionCalculatedTotalRect.height)
        return unionCalculatedTotalRect.height
    }

    private func recursiveUnionInDepthFor(view: UIView) -> CGRect {
        var totalRect: CGRect = .zero

        // 모든 자식 View의 컨트롤의 크기를 재귀적으로 호출하며 최종 영역의 크기를 설정
        for subView in view.subviews {
            print(totalRect)
            totalRect = totalRect.union(recursiveUnionInDepthFor(view: subView))
        }

        // 최종 계산 영역의 크기를 반환
        return totalRect.union(view.frame)
    }
}
