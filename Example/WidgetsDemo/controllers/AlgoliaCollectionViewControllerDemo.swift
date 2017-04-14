//
//  AlgoliaCollectionViewControllerDemo.swift
//  Example
//
//  Created by Guy Daher on 14/04/2017.
//
//

import UIKit
import InstantSearch
// TODO: Should remove that when moved highlight logic in IS
import InstantSearchCore

class AlgoliaCollectionViewControllerDemo: AlgoliaCollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 90, height: 120)
        
        hitsCollectionView = HitsCollectionWidget(frame: self.view.frame, collectionViewLayout: layout)
        

        hitsCollectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil) , forCellWithReuseIdentifier: "collectionViewCell")
        hitsCollectionView.backgroundColor = .white
        
        self.view.addSubview(hitsCollectionView)
        
        AlgoliaSearchManager.instance.instantSearchBinder.addAllWidgets(in: self.view)
        hitsCollectionView.hitDataSource = self
        hitsCollectionView.hitDelegate = self
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath, containing hit: [String : Any]) -> UICollectionViewCell {
        let cell = hitsCollectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! CollectionViewCell
        
        cell.name.text = hit["name"] as? String
        
        cell.name.highlightedText = SearchResults.highlightResult(hit: hit, path: "name")?.value
        cell.name.highlightedTextColor = .black
        cell.name.highlightedBackgroundColor = .yellow
        
        cell.salePrice.text = String(hit["salePrice"] as! Double)
        
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath, containing hit: [String : Any]) {
        
    }
}
