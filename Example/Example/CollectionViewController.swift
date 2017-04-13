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

class CollectionViewController: UICollectionViewController, HitCollectionViewDataSource {

    var instantSearchBinder: InstantSearchBinder!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let hitCollectionWidget = collectionView as! HitsCollectionWidget
        instantSearchBinder.add(widget: hitCollectionWidget)
        hitCollectionWidget.hitDataSource = self

        // Do any additional setup after loading the view.
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItem hit: [String: Any], at indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! CollectionViewCell
        
        cell.name.text = hit["name"] as? String
        
        cell.name.highlightedText = SearchResults.highlightResult(hit: hit, path: "name")?.value
        cell.name.highlightedTextColor = .black
        cell.name.highlightedBackgroundColor = .yellow
        
        cell.salePrice.text = String(hit["salePrice"] as! Double)
        cell.backgroundColor = UIColor.lightGray
        
        return cell
    }

}

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet var name: UILabel!
    @IBOutlet var salePrice: UILabel!
}

fileprivate let itemsPerRow: CGFloat = 2
fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 30.0, bottom: 50.0, right: 30.0)


extension CollectionViewController : UICollectionViewDelegateFlowLayout {
    
    
    //1
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        //2
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    //3
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    // 4
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
