//
//  Created with ♥ by BanklessDAO contributors on 2021-11-16.
//  Copyright (C) 2021 BanklessDAO.

//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU Affero General Public License as
//  published by the Free Software Foundation, either version 3 of the
//  License, or (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU Affero General Public License for more details.
//
//  You should have received a copy of the GNU Affero General Public License
//  along with this program.  If not, see https://www.gnu.org/licenses/.
//
    
// NOTE: This implementation is based on (read "copy-pasted with a few modifications")
// another reference implementation. Far from ideal, but does the job here, and
// is not a critical component, being a pretty-high-level solution to a layout problem on iOS.

import Foundation
import UIKit

public extension UICollectionView {
    convenience init(
        frame: CGRect = .zero,
        featuredNewsCollectionFlowLayout: FeaturedNewsCollectionFlowLayout
    ) {
        self.init(frame: frame, collectionViewLayout: featuredNewsCollectionFlowLayout)
        decelerationRate = UIScrollView.DecelerationRate.fast
    }
}

open class FeaturedNewsCollectionFlowLayout: UICollectionViewFlowLayout {
    private var lastCollectionViewSize: CGSize = CGSize.zero
    private var lastScrollDirection: UICollectionView.ScrollDirection!
    private var lastItemSize: CGSize = CGSize.zero
    var pageWidth: CGFloat {
        switch scrollDirection {
        case .horizontal:
            return itemSize.width + minimumLineSpacing
        case .vertical:
            return itemSize.height + minimumLineSpacing
        default:
            return 0
        }
    }
    
    public override init() {
        super.init()
        scrollDirection = .horizontal
        lastScrollDirection = scrollDirection
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        scrollDirection = .horizontal
        lastScrollDirection = scrollDirection
    }
    
    override open func invalidateLayout(with context: UICollectionViewLayoutInvalidationContext) {
        super.invalidateLayout(with: context)
        guard let collectionView = collectionView else { return }
        
        let currentCollectionViewSize = collectionView.bounds.size
        if !currentCollectionViewSize
            .equalTo(lastCollectionViewSize)
            || lastScrollDirection != scrollDirection
            || lastItemSize != itemSize
        {
            switch scrollDirection {
                
            case .horizontal:
                break
            case .vertical:
                let inset = (currentCollectionViewSize.height - itemSize.height) / 2
                collectionView.contentInset = UIEdgeInsets(
                    top: inset, left: 0, bottom: inset, right: 0
                )
                collectionView.contentOffset = CGPoint(x: 0, y: -inset)
            default:
                collectionView.contentInset = UIEdgeInsets(
                    top: 0, left: 0, bottom: 0, right: 0
                )
                collectionView.contentOffset = .zero
            }
            
            lastCollectionViewSize = currentCollectionViewSize
            lastScrollDirection = scrollDirection
            lastItemSize = itemSize
        }
    }
    
    override open func targetContentOffset(
        forProposedContentOffset proposedContentOffset: CGPoint,
        withScrollingVelocity velocity: CGPoint
    ) -> CGPoint {
        guard let collectionView = collectionView else { return proposedContentOffset }
        
        let proposedRect: CGRect = determineProposedRect(
            collectionView: collectionView,
            proposedContentOffset: proposedContentOffset
        )
        
        guard let layoutAttributes = layoutAttributesForElements(in: proposedRect),
              let candidateAttributesForRect = attributesForRect(
                collectionView: collectionView,
                layoutAttributes: layoutAttributes,
                proposedContentOffset: proposedContentOffset
              ) else { return proposedContentOffset }
        
        var newOffset: CGFloat
        let offset: CGFloat
        switch scrollDirection {
        case .horizontal:
            newOffset = candidateAttributesForRect.center.x - collectionView.bounds.size.width / 2
            offset = newOffset - collectionView.contentOffset.x
            
            if (velocity.x < 0 && offset > 0) || (velocity.x > 0 && offset < 0) {
                let pageWidth = itemSize.width + minimumLineSpacing
                newOffset += velocity.x > 0 ? pageWidth : -pageWidth
            }
            return CGPoint(x: newOffset, y: proposedContentOffset.y)
            
        case .vertical:
            newOffset = candidateAttributesForRect.center.y - collectionView.bounds.size.height / 2
            offset = newOffset - collectionView.contentOffset.y
            
            if (velocity.y < 0 && offset > 0) || (velocity.y > 0 && offset < 0) {
                let pageHeight = itemSize.height + minimumLineSpacing
                newOffset += velocity.y > 0 ? pageHeight : -pageHeight
            }
            return CGPoint(x: proposedContentOffset.x, y: newOffset)
            
        default:
            return .zero
        }
    }
    
    public func scrollToPage(index: Int, animated: Bool) {
        guard let collectionView = collectionView else { return }
        
        let proposedContentOffset: CGPoint
        let shouldAnimate: Bool
        switch scrollDirection {
        case .horizontal:
            let pageOffset = CGFloat(index) * pageWidth - collectionView.contentInset.left
            proposedContentOffset = CGPoint(x: pageOffset, y: collectionView.contentOffset.y)
            shouldAnimate = abs(collectionView.contentOffset.x - pageOffset) > 1 ? animated : false
        case .vertical:
            let pageOffset = CGFloat(index) * pageWidth - collectionView.contentInset.top
            proposedContentOffset = CGPoint(x: collectionView.contentOffset.x, y: pageOffset)
            shouldAnimate = abs(collectionView.contentOffset.y - pageOffset) > 1 ? animated : false
        default:
            proposedContentOffset = .zero
            shouldAnimate = false
        }
        collectionView.setContentOffset(proposedContentOffset, animated: shouldAnimate)
    }
}

extension FeaturedNewsCollectionFlowLayout {
    func determineProposedRect(
        collectionView: UICollectionView,
        proposedContentOffset: CGPoint
    ) -> CGRect {
        let size = collectionView.bounds.size
        let origin: CGPoint
        switch scrollDirection {
        case .horizontal:
            origin = CGPoint(x: proposedContentOffset.x, y: collectionView.contentOffset.y)
        case .vertical:
            origin = CGPoint(x: collectionView.contentOffset.x, y: proposedContentOffset.y)
        default:
            origin = .zero
        }
        return CGRect(origin: origin, size: size)
    }
    
    func attributesForRect(
        collectionView: UICollectionView,
        layoutAttributes: [UICollectionViewLayoutAttributes],
        proposedContentOffset: CGPoint
    ) -> UICollectionViewLayoutAttributes? {
        
        var candidateAttributes: UICollectionViewLayoutAttributes?
        let proposedCenterOffset: CGFloat
        
        switch scrollDirection {
        case .horizontal:
            proposedCenterOffset = proposedContentOffset.x + collectionView.bounds.size.width / 2
        case .vertical:
            proposedCenterOffset = proposedContentOffset.y + collectionView.bounds.size.height / 2
        default:
            proposedCenterOffset = .zero
        }
        
        for attributes in layoutAttributes {
            guard attributes.representedElementCategory == .cell else { continue }
            guard candidateAttributes != nil else {
                candidateAttributes = attributes
                continue
            }
            
            switch scrollDirection {
            case .horizontal where abs(
                attributes.center.x - proposedCenterOffset
            ) < abs(
                candidateAttributes!.center.x - proposedCenterOffset
            ):
                candidateAttributes = attributes
            case .vertical where abs(
                attributes.center.y - proposedCenterOffset
            ) < abs(
                candidateAttributes!.center.y - proposedCenterOffset
            ):
                candidateAttributes = attributes
            default:
                continue
            }
        }
        return candidateAttributes
    }
    
    open override func layoutAttributesForElements(
        in rect: CGRect
    ) -> [UICollectionViewLayoutAttributes]? {
        let attr = super.layoutAttributesForElements(in: rect)
        var attributes = [UICollectionViewLayoutAttributes]()
        for itemAttributes in attr! {
            let itemAttributesCopy = itemAttributes.copy() as! UICollectionViewLayoutAttributes
            attributes.append(itemAttributesCopy)
        }
        
        if attributes.count == 1 {
            
            if let currentAttribute = attributes.first {
                currentAttribute.frame = CGRect(
                    x: self.sectionInset.left,
                    y: currentAttribute.frame.origin.y,
                    width: currentAttribute.frame.size.width,
                    height: currentAttribute.frame.size.height
                )
            }
        } else {
            var sectionHeight: CGFloat = 0
            
            attributes.forEach { layoutAttribute in
                guard layoutAttribute.representedElementCategory == .supplementaryView else {
                    return
                }
                
                if layoutAttribute.representedElementKind
                    == UICollectionView.elementKindSectionHeader
                {
                    sectionHeight = layoutAttribute.frame.size.height
                }
            }
            
            attributes.forEach { layoutAttribute in
                guard layoutAttribute.representedElementCategory == .cell else {
                    return
                }
                
                if layoutAttribute.frame.origin.x == 0 {
                    sectionHeight = max(layoutAttribute.frame.minY, sectionHeight)
                }
                
                layoutAttribute.frame = CGRect(
                    origin: CGPoint(x: layoutAttribute.frame.origin.x, y: sectionHeight),
                    size: layoutAttribute.frame.size
                )
                
            }
        }
        return attributes
    }
}
