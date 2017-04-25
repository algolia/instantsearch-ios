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
    
    lazy var viewModel: RefinementMenuViewModelDelegate = {
        return self.refinementViewDelegate.viewModel
    }()
    
    @objc public weak var tableDataSource: RefinementTableViewDataSource?
    @objc public weak var tableDelegate: RefinementTableViewDelegate?
    @objc public weak var collectionDataSource: RefinementCollectionViewDataSource?
    @objc public weak var collectionDelegate: RefinementCollectionViewDelegate?
    
    convenience public init(table: RefinementTableWidget) {
        self.init(refinementView: table)
    }
    
//    convenience public init(collection: HitsCollectionWidget) {
//        self.init(hitsView: collection)
//    }
    
    init(refinementView: RefinementMenuViewDelegate) {
        self.refinementViewDelegate = refinementView
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
        (refinementViewDelegate as! UITableView).deselectRow(at: indexPath, animated: true)
        viewModel.didSelectRow(at: indexPath)
    }
}
