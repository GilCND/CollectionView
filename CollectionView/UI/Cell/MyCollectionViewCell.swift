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
    var targetURL = ""
    var task: DispatchWorkItem?
 
    override func prepareForReuse() {
        imageView.image = nil
        task?.cancel()
    }
    
    public func configure(with stringURL: String?, with stringId: Int?) {
        
        var imageData: Data?
        
        guard let stringURL = stringURL, let stringId = stringId else { return }
        targetURL = stringURL
        let imageUrl = URL(string: targetURL)
        
        task = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            do {
                guard let imageUrl = imageUrl else { return }
                imageData = try Data(contentsOf: imageUrl)
            } catch {
                print("Error, converting the data")
            }
            guard let imageData = imageData else { return }
            let thumbUiData = UIImage(data: imageData)?.resizeImage(120 , opaque: true)
            DispatchQueue.main.async {
                self.imageView.image = thumbUiData
            }
        }
        guard let task = task else { return }
        DispatchQueue.global(qos: .background).async(execute: task)
    }
    
    static func nib() -> UINib{
        return UINib(nibName: "MyCollectionViewCell", bundle: nil)
    }
}
