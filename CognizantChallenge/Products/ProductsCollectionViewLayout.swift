//
//  MainCollectionViewLayout.swift
//  Cognizant
//
//  Created by Dave Caddy on 24/5/21.
//

import UIKit

class ProductsCollectionViewLayout: UICollectionViewFlowLayout {
    
    var columnCountProvider: ((_ collectionViewBounds: CGRect) -> Int)?
    private var numberOfColumns: Int {
        get {
            return self.columnCountProvider?(self.collectionView?.bounds ?? .zero) ?? 1
        }
    }
    
    init(minimumInteritemSpacing: CGFloat = 0.0, minimumLineSpacing: CGFloat = 0.0, sectionInset: UIEdgeInsets = .zero) {
        super.init()
        
        self.scrollDirection = .vertical
        self.minimumInteritemSpacing = minimumInteritemSpacing
        self.minimumLineSpacing = minimumLineSpacing
        self.sectionInset = sectionInset
        self.estimatedItemSize = CGSize(width: 200.0, height: 100.0)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let la = super.layoutAttributesForItem(at: indexPath) else { return nil }
        guard let cv = self.collectionView else { return la }

        let insets = self.sectionInset.left + self.sectionInset.right + cv.safeAreaInsets.left + cv.safeAreaInsets.right
        let spacing = self.minimumInteritemSpacing * CGFloat(self.numberOfColumns - 1)

        la.bounds.size.width = floor((cv.bounds.width - insets - spacing) / CGFloat(self.numberOfColumns))

        return la
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let la = super.layoutAttributesForElements(in: rect)!.map { $0.copy() as! UICollectionViewLayoutAttributes }

        let layoutAttributes = la.compactMap { layoutAttribute in
            return layoutAttribute.representedElementCategory == .cell ? layoutAttributesForItem(at: layoutAttribute.indexPath) : layoutAttribute
        }

        return layoutAttributes
    }
}
