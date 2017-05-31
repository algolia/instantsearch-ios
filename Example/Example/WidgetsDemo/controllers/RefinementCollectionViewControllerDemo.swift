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
        
        let searchBar = SearchBarWidget(frame: CGRect(x: 20, y: 60, width: self.view.frame.width - 40, height: 40))
        self.view.addSubview(searchBar)
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        refinementCollectionView = RefinementCollectionWidget(frame: CGRect(x: 10, y: 100, width: self.view.frame.width - 20, height: self.view.frame.height - 100), collectionViewLayout: layout)
        
        refinementCollectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil) , forCellWithReuseIdentifier: "collectionViewCell")
        refinementCollectionView.backgroundColor = .white
        refinementCollectionView.attribute = "category"
        
        self.view.addSubview(refinementCollectionView)
        
        InstantSearch.reference.addAllWidgets(in: self.view)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath, containing facet: String, with count: Int, is refined: Bool) -> UICollectionViewCell {
        let cell = refinementCollectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! CollectionViewCell
        
        cell.name.text = facet
        cell.salePrice.text = "\(count) \(refined)"
        cell.backgroundColor = refined ? .green : .red
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath, containing facet: String, with count: Int, is refined: Bool) {
        
    }
    
    func viewForNoResults(in collectionView: UICollectionView) -> UIView {
        let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0,
                                                         width: collectionView.bounds.size.width,
                                                         height: collectionView.bounds.size.height))
        noDataLabel.text          = "HEY! NO RESULTS!"
        noDataLabel.textColor     = UIColor.black
        noDataLabel.textAlignment = .left
        
        return noDataLabel
    }
}

fileprivate let itemsPerRow: CGFloat = 3
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
