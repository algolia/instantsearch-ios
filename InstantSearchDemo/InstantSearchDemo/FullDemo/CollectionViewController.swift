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

class CollectionViewController: UIViewController, HitsCollectionViewDataSource {

    @IBOutlet var hitCollectionWidget: HitsCollectionWidget!
    var hitsController: HitsController!
    var instantSearch: InstantSearch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hitsController = HitsController(collection: hitCollectionWidget)
        hitCollectionWidget.dataSource = hitsController
        hitCollectionWidget.delegate = hitsController
        hitsController.collectionDataSource = self
        
        hitCollectionWidget.register(UINib(nibName: "CollectionViewCell", bundle: nil) , forCellWithReuseIdentifier: "collectionViewCell")
        instantSearch = InstantSearch.shared
        instantSearch.registerAllWidgets(in: self.view)
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
