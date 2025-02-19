//
//  CarouseLayoutVertical.swift
//  Archive
//
//  Created by 송재곤 on 1/21/25.
//


import UIKit

class CarouseLayoutVertical: UICollectionViewFlowLayout {
    
    public var sideItemScale: CGFloat = 0.8
    public var sideItemAlpha: CGFloat = 0.1
    public var minAlpha: CGFloat = 0.1
    public var spacing: CGFloat = 1
    
    private var isSetup: Bool = false
    
    override public func prepare() {
        super.prepare()
        if !isSetup {
            setupLayout()
            isSetup = true
        }
    }
    
    private func setupLayout() {
        guard let collectionView = self.collectionView else { return }
        
        let collectionViewSize = collectionView.bounds.size
        
        let yInset = (collectionViewSize.height - self.itemSize.height) / 2
        let xInset = (collectionViewSize.width - self.itemSize.width) / 2

        self.sectionInset = UIEdgeInsets(top: yInset, left: xInset, bottom: yInset, right: xInset)

        
        // 최소 간격 계산 (스케일 효과를 고려하여 재조정)
        let itemHeight = self.itemSize.height
        let scaledItemOffset = itemHeight * (1 - self.sideItemScale) / 2
        self.minimumLineSpacing = spacing + scaledItemOffset
        
        self.scrollDirection = .vertical
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
        guard let collectionView = self.collectionView else { return attributes }
        
        let collectionCenter = collectionView.bounds.height / 2
        let contentOffset = collectionView.contentOffset.y
        let center = attributes.center.y - contentOffset
        
        let maxDistance = 10 * (self.itemSize.height + self.minimumLineSpacing)
        let distance = min(abs(collectionCenter - center), maxDistance)
        
        let ratio = (maxDistance - distance) / maxDistance //11
//        let ratio = (maxDistance - UIScreen.main.screenHeight/2) / maxDistance
        
        let alpha = max(ratio * (0.8 - self.sideItemAlpha) + self.sideItemAlpha, minAlpha)
        let scale = ratio * (1 - self.sideItemScale) + self.sideItemScale
        
        attributes.alpha = alpha
        if abs(collectionCenter - center) > maxDistance {
            attributes.alpha = 0
        }
        if abs(distance) <= 0.2 {
            attributes.alpha = 1
        }
        
        var transform = CATransform3DIdentity
        transform = CATransform3DScale(transform, scale, scale, 1)
        attributes.transform3D = transform
        
        return attributes
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = self.collectionView else {
            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
        }
        
        let targetRect = CGRect(x: 0, y: proposedContentOffset.y, width: collectionView.frame.width, height: collectionView.frame.height)
        guard let rectAttributes = super.layoutAttributesForElements(in: targetRect) else { return .zero }
        
        var offsetAdjustment = CGFloat.greatestFiniteMagnitude
        let verticalCenter = proposedContentOffset.y + collectionView.frame.height / 2
        print(verticalCenter)
        for layoutAttributes in rectAttributes {
            let itemVerticalCenter = layoutAttributes.center.y
            if abs(itemVerticalCenter - verticalCenter) < abs(offsetAdjustment) {
                offsetAdjustment = itemVerticalCenter - verticalCenter
            }
        }
        
        return CGPoint(x: proposedContentOffset.x, y: proposedContentOffset.y + offsetAdjustment)
    }
}
