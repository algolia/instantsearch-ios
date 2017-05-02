//
//  RefinementViewController
//  InstantSearch
//
//  Created by Guy Daher on 19/04/2017.
//
//

import UIKit

@objc public class RefinementViewController: NSObject {
    
    var refinementViewDelegate: RefinementMenuViewDelegate
    var viewModel: RefinementMenuViewModelDelegate
    
    @objc public weak var tableDataSource: RefinementTableViewDataSource?
    @objc public weak var tableDelegate: RefinementTableViewDelegate?
    @objc public weak var collectionDataSource: RefinementCollectionViewDataSource?
    @objc public weak var collectionDelegate: RefinementCollectionViewDelegate?
    
    convenience public init(table: RefinementTableWidget) {
        self.init(refinementView: table)
    }
    
    convenience public init(collection: RefinementCollectionWidget) {
        self.init(refinementView: collection)
    }
    
    init(refinementView: RefinementMenuViewDelegate) {
        self.refinementViewDelegate = refinementView
        self.viewModel = refinementView.viewModel
        super.init()
    }
}

extension RefinementViewController: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let facetValue = viewModel.facetForRow(at: indexPath)
        let isRefined = viewModel.isRefined(at: indexPath)
        return tableDataSource?.tableView(tableView, cellForRowAt: indexPath, containing: facetValue.value, with: facetValue.count, is: isRefined) ?? UITableViewCell()
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }
}

extension RefinementViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectRow(at: indexPath)
    }
}

extension RefinementViewController: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let facetValue = viewModel.facetForRow(at: indexPath)
        let isRefined = viewModel.isRefined(at: indexPath)
        return collectionDataSource?.collectionView(collectionView, cellForItemAt: indexPath, containing: facetValue.value, with: facetValue.count, is: isRefined) ?? UICollectionViewCell()
    }
}

extension RefinementViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectRow(at: indexPath)
    }
}
