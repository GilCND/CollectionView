//
//  DetailsViewController.swift
//  CollectionView
//
//  Created by Felipe Gil on 2021-08-24.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var imageToLoad = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let image = URL(string: imageToLoad) else { return }
        let imageData = try! Data(contentsOf: image)
        imageView.image = UIImage(data: imageData)
        
    }
}
