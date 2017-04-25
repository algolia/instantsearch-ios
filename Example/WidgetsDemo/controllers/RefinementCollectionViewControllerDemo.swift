//
//  RefinementCollectionViewControllerDemo.swift
//  Example
//
//  Created by Guy Daher on 14/04/2017.
//
//

import UIKit
import InstantSearch

class RefinementCollectionViewControllerDemo: RefinementCollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        refinementCollectionView = RefinementCollectionWidget(frame: self.navigationController?.view.bounds ?? self.view.bounds, collectionViewLayout: layout)
        
        refinementCollectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil) , forCellWithReuseIdentifier: "collectionViewCell")
        refinementCollectionView.backgroundColor = .white
        
        self.view.addSubview(refinementCollectionView)
        
        AlgoliaSearchManager.instance.instantSearchBinder.addAllWidgets(in: self.view)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath, containing facet: String, with count: Int, is refined: Bool) -> UICollectionViewCell {
        let cell = refinementCollectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! CollectionViewCell
        
        cell.name.text = facet
        cell.salePrice.text = "\(count) \(refined)"
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath, containing facet: String, with count: Int, is refined: Bool) {
        
    }
}

fileprivate let itemsPerRow: CGFloat = 4.0
fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)

extension RefinementCollectionViewControllerDemo : UICollectionViewDelegateFlowLayout {
    
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
