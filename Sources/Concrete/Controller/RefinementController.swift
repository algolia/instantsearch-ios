//
//  RefinementController
//  InstantSearch
//
//  Created by Guy Daher on 19/04/2017.
//
//

import UIKit

/// A controller object that manages a Refinement Widget.
/// It takes care of interacting with InstantSearch and offer clear and easy to use dataSource and delegate methods.
/// - tableDataSource: DataSource to specify the layout of a table refinement cell.
/// - tableDelegate: Delegate to specify the behavior when a table refinement cell is selected.
/// - collectionDataSource: DataSource to specify the layout of a collection refinement cell.
/// - collectionDelegate: Delegate to specify the behavior when a collection refinement cell is selected.
@objcMembers public class RefinementController: NSObject {
    
    /// Reference to the viewModel associated with the refinement widget.
    var viewModel: RefinementMenuViewModelDelegate
    
    /// DataSource that takes care of the content of the table refinement widget.
    @objc public weak var tableDataSource: RefinementTableViewDataSource?
    
    /// Delegate that takes care of the behavior of the table refinement widget.
    @objc public weak var tableDelegate: RefinementTableViewDelegate?
    
    /// DataSource that takes care of the content of the collection refinement widget.
    @objc public weak var collectionDataSource: RefinementCollectionViewDataSource?
    
    /// Delegate that takes care of the behavior of the collection refinement widget.
    @objc public weak var collectionDelegate: RefinementCollectionViewDelegate?
    
    @objc convenience public init(table: RefinementTableWidget) {
        self.init(refinementView: table)
    }
    
    @objc convenience public init(collection: RefinementCollectionWidget) {
        self.init(refinementView: collection)
    }
    
    @objc init(refinementView: RefinementMenuViewDelegate) {
        self.viewModel = refinementView.viewModel
        super.init()
    }
}

extension RefinementController: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let facetValue = viewModel.facetForRow(at: indexPath)
        let isRefined = viewModel.isRefined(at: indexPath)
        return tableDataSource?.tableView(tableView,
                                          cellForRowAt: indexPath,
                                          containing: facetValue.value,
                                          with: facetValue.count,
                                          is: isRefined) ?? UITableViewCell()
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections: Int = 0
        
        if viewModel.numberOfRows() > 0 {
            tableView.separatorStyle = .singleLine
            numOfSections            = 1
            tableView.backgroundView = nil
        } else {
            tableView.separatorStyle  = .none
            
            if let noResultView = tableDataSource?.viewForNoResults?(in: tableView) {
                tableView.backgroundView  = noResultView
            } else { // Default view
                let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0,
                                                                 width: tableView.bounds.size.width,
                                                                 height: tableView.bounds.size.height))
                noDataLabel.text          = "No results available"
                noDataLabel.textColor     = UIColor.black
                noDataLabel.textAlignment = .center
                tableView.backgroundView  = noDataLabel
                
            }
        }
        return numOfSections
    }
}

extension RefinementController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectRow(at: indexPath)
    }
}

extension RefinementController: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let facetValue = viewModel.facetForRow(at: indexPath)
        let isRefined = viewModel.isRefined(at: indexPath)
        return collectionDataSource?.collectionView(collectionView,
                                                    cellForItemAt: indexPath,
                                                    containing: facetValue.value,
                                                    with: facetValue.count,
                                                    is: isRefined) ?? UICollectionViewCell()
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        var numOfSections: Int = 0
        
        if viewModel.numberOfRows() > 0 {
            numOfSections            = 1
            collectionView.backgroundView = nil
        } else {
            if let noResultView = collectionDataSource?.viewForNoResults?(in: collectionView) {
                collectionView.backgroundView  = noResultView
            } else { // Default View
                let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0,
                                                                 width: collectionView.bounds.size.width,
                                                                 height: collectionView.bounds.size.height))
                noDataLabel.text          = "No results available"
                noDataLabel.textColor     = UIColor.black
                noDataLabel.textAlignment = .center
                collectionView.backgroundView  = noDataLabel
            }
        }
        return numOfSections
        
    }
}

extension RefinementController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectRow(at: indexPath)
    }
}
