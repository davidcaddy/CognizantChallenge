//
//  MainCollectionViewCell.swift
//  Cognizant
//
//  Created by Dave Caddy on 24/5/21.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    
    var onPrepareForReuse: (() -> Void)?
    
    private func commonInit() {
        self.layer.cornerRadius = 0.0
        self.layer.borderWidth = 0.0
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 0.5
        self.layer.masksToBounds = false
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.onPrepareForReuse?()
    }
}
