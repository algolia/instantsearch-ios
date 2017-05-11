//
//  collectionViewController.swift
//  Example
//
//  Created by Guy Daher on 07/04/2017.
//
//

import UIKit
import InstantSearch
import InstantSearchCore

class CollectionViewController: UIViewController, HitCollectionViewDataSource {

    @IBOutlet var hitCollectionWidget: HitsCollectionWidget!
    var hitsViewController: HitsViewController!
    var instantSearchBinder: InstantSearchBinder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hitsViewController = HitsViewController(collection: hitCollectionWidget)
        hitCollectionWidget.dataSource = hitsViewController
        hitCollectionWidget.delegate = hitsViewController
        hitsViewController.collectionDataSource = self
        // hitsViewController.collectionDelegate = self
        
        hitCollectionWidget.register(UINib(nibName: "CollectionViewCell", bundle: nil) , forCellWithReuseIdentifier: "collectionViewCell")
        instantSearchBinder = InstantSearch.reference
        instantSearchBinder.addAllWidgets(in: self.view)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath, containing hit: [String: Any]) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! CollectionViewCell
        
        cell.name.text = hit["name"] as? String
        
        cell.name.highlightedText = SearchResults.highlightResult(hit: hit, path: "name")?.value
        cell.name.highlightedTextColor = .black
        cell.name.highlightedBackgroundColor = .yellow
        
        cell.salePrice.text = String(hit["salePrice"] as! Double)
        cell.backgroundColor = UIColor.lightGray
        
        return cell
    }

}

fileprivate let itemsPerRow: CGFloat = 2
fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 30.0, bottom: 50.0, right: 30.0)


extension CollectionViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
