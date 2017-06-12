//
//  HitsCollectionViewControllerDemo.swift
//  Example
//
//  Created by Guy Daher on 14/04/2017.
//
//

import UIKit
import InstantSearch
// TODO: Should remove that when moved highlight logic in IS
import InstantSearchCore

class HitsCollectionViewControllerDemo: HitsCollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let searchBar = SearchBarWidget(frame: CGRect(x: 20, y: 70, width: self.view.frame.width - 40, height: 40))
        self.view.addSubview(searchBar)
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        hitsCollectionView = HitsCollectionWidget(frame: CGRect(x: 10, y: 110, width: self.view.frame.width - 20, height: self.view.frame.height - 100), collectionViewLayout: layout)

        hitsCollectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil) , forCellWithReuseIdentifier: "collectionViewCell")
        hitsCollectionView.backgroundColor = .white
        
        self.view.addSubview(hitsCollectionView)
        
        InstantSearch.shared.addAllWidgets(in: self.view)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath, containing hit: [String : Any]) -> UICollectionViewCell {
        let cell = hitsCollectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! CollectionViewCell
        
        cell.name.text = hit["name"] as? String
        
        cell.name.highlightedText = SearchResults.highlightResult(hit: hit, path: "name")?.value
        cell.name.highlightedTextColor = .black
        cell.name.highlightedBackgroundColor = .yellow
        
        cell.salePrice.text = String(hit["salePrice"] as! Double)
        
        cell.backgroundColor = .gray
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath, containing hit: [String : Any]) {
        
    }
}

fileprivate let itemsPerRow: CGFloat = 4.0
fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)

extension HitsCollectionViewControllerDemo : UICollectionViewDelegateFlowLayout {
    
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
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
