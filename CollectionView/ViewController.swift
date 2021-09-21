//
//  ViewController.swift
//  CollectionView
//
//  Created by Felipe Gil on 2021-08-23.
//
/*
 Can I challenge you to show remote images in your collection view instead of the local
 ones? Also, you could try having more items in your data source, something like 30?! Please
 use different and large images to avoid quick caching. By doing that you'll face a very
 common challenge regarding cell reusability.
 */



import UIKit


class ViewController: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView!
    let apiService = ApiService()
    final let jsonURL = "https://gist.githubusercontent.com/GilCND/e28acf7ad23f0ef02947f1d77d82226d/raw/ef8f147baf6b78123f08787ec076ee1d3e8130e4/collectionViewData.json"
    var places = [PlacesModel]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = UICollectionViewFlowLayout()
        
        collectionView.collectionViewLayout = layout
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MyCollectionViewCell.nib(), forCellWithReuseIdentifier: MyCollectionViewCell.identifier)
        loadData()
    }
    
    private func loadData() {
        apiService.getData(Url: jsonURL) { (dataFromAPI: PlacesResponse) in
            self.places = dataFromAPI.places
            self.collectionView.reloadData()
        }
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        guard let detailsViewController = storyBoard.instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController else { return }

        print("You tapped an item")
        detailsViewController.imageToLoad = places[indexPath.item].imageURL
       self.navigationController?.pushViewController(detailsViewController, animated: true)
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return places.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyCollectionViewCell.identifier, for: indexPath) as? MyCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: places[indexPath.row].imageURL, with: places[indexPath.row].id)
        
        return cell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = view.frame.size.width / 4
        let width = view.frame.size.width / 3
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 35, left: 20, bottom: 0, right: 20)
    }
}
extension UIImage {
    func resizeImage(_ dimension: CGFloat, opaque: Bool, contentMode: UIView.ContentMode = .scaleAspectFit) -> UIImage {
        var width: CGFloat
        var height: CGFloat
        var newImage: UIImage
        
        let size = self.size
        let aspectRatio =  size.width/size.height
        
        switch contentMode {
        case .scaleAspectFit:
            if aspectRatio > 1 {                            // Landscape image
                width = dimension
                height = dimension / aspectRatio
            } else {                                        // Portrait image
                height = dimension
                width = dimension * aspectRatio
            }
            
        default:
            fatalError("UIIMage.resizeToFit(): FATAL: Unimplemented ContentMode")
        }
        
        let renderFormat = UIGraphicsImageRendererFormat.default()
        renderFormat.opaque = opaque
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: width, height: height), format: renderFormat)
        newImage = renderer.image {
            (context) in
            self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
        }
        
        
        return newImage
    }
}
