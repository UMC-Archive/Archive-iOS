//
//  CarouseLayout.swift
//  Archive
//
//  Created by 송재곤 on 1/16/25.
//

import UIKit

class CarouselLayout2: UICollectionViewFlowLayout { // 투명도가 아닌 view의 업데이트를 통해 뒷열의 셀을 어둡게하는 부분만 다름
    
    public var sideItemScale: CGFloat = 0.5
    public var sideItemAlpha: CGFloat = 0.5
    public var spacing: CGFloat = 0

    public var isPagingEnabled: Bool = false
    
    private var isSetup: Bool = false
    
    override public func prepare() {
        super.prepare()
        if isSetup == false {
            setupLayout()
            isSetup = true
        }
    }
    
    private func setupLayout() {
        guard let collectionView = self.collectionView else {return}
                
        let collectionViewSize = collectionView.bounds.size
        
        let xInset = (collectionViewSize.width - self.itemSize.width) / 2
        let yInset = (collectionViewSize.height - self.itemSize.height) / 2
        
        self.sectionInset = UIEdgeInsets(top: yInset, left: xInset, bottom: yInset, right: xInset)
        
        let itemWidth = self.itemSize.width
        
        let scaledItemOffset =  (itemWidth - (itemWidth*(self.sideItemScale + (1 - self.sideItemScale)/2))) / 2
        self.minimumLineSpacing = spacing - scaledItemOffset * 4

        self.scrollDirection = .horizontal
    }
    
    public override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let superAttributes = super.layoutAttributesForElements(in: rect),
            let attributes = NSArray(array: superAttributes, copyItems: true) as? [UICollectionViewLayoutAttributes]
            else { return nil }
        
        return attributes.map({ self.transformLayoutAttributes(attributes: $0) })
    }
    
    private func transformLayoutAttributes(attributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        
        guard let collectionView = self.collectionView else {return attributes}
        
        let collectionCenter = collectionView.frame.size.width / 2
        let contentOffset = collectionView.contentOffset.x
        let center = attributes.center.x - contentOffset
        
        let maxDistance = 2*(self.itemSize.width + self.minimumLineSpacing)
        let distance = min(abs(collectionCenter - center), maxDistance)
        
        let ratio = (maxDistance - distance)/maxDistance
        
        
        let scale = ratio * (1 - self.sideItemScale) + self.sideItemScale
        
        let cell = collectionView.cellForItem(at: attributes.indexPath) as? GenreRecommendedCollectionViewCell
        //비율에 따라 어두운 정도 설정 (0 ~ 0.8)
        let darkRatio = max(ratio, 0.2) // 0 ~ 1 사이의 비율을 어두운 정도로 변환
        cell?.updateOverlayVisibility(1 - darkRatio)
        
        
        
        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
        let dist = attributes.frame.midX - visibleRect.midX
        var transform = CATransform3DScale(CATransform3DIdentity, scale, scale, 1)
        
        transform = CATransform3DTranslate(transform, 0, 0, -abs(dist/1000))
        attributes.transform3D = transform
        
        return attributes
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {

        guard let collectionView = self.collectionView else {
            let latestOffset = super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
            return latestOffset
        }

        let targetRect = CGRect(x: proposedContentOffset.x, y: 0, width: collectionView.frame.width, height: collectionView.frame.height)
        guard let rectAttributes = super.layoutAttributesForElements(in: targetRect) else { return .zero }

        var offsetAdjustment = CGFloat.greatestFiniteMagnitude
        let horizontalCenter = proposedContentOffset.x + collectionView.frame.width / 2

        for layoutAttributes in rectAttributes {
            let itemHorizontalCenter = layoutAttributes.center.x
            if (itemHorizontalCenter - horizontalCenter).magnitude < offsetAdjustment.magnitude {
                offsetAdjustment = itemHorizontalCenter - horizontalCenter
            }
        }

        return CGPoint(x: proposedContentOffset.x + offsetAdjustment, y: proposedContentOffset.y)
    }
}
