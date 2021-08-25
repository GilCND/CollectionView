//
//  MyCollectionViewCell.swift
//  CollectionView
//
//  Created by Felipe Gil on 2021-08-23.
//

import UIKit

class MyCollectionViewCell: UICollectionViewCell {
    @IBOutlet var imageView: UIImageView!
    static let identifier = "MyCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    public func configure(with image: UIImage) {
        imageView.image = image
    }
    static func nib() -> UINib{
        return UINib(nibName: "MyCollectionViewCell", bundle: nil)
    }

}
