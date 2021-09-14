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
        let imageUrl = URL(string: places[indexPath.row].imageURL)
        guard let imageUrl = imageUrl else {
            print("Error image path is Nil")
            return UICollectionViewCell()
        }
        let imageData = try! Data(contentsOf: imageUrl)
        let thumbUiImage = UIImage(data: imageData)
        cell.imageView.image = thumbUiImage
        
        return cell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = view.frame.size.width / 4
        let width = view.frame.size.width / 4
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 35, left: 20, bottom: 0, right: 20)
    }
}
