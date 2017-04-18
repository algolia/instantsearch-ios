//
//  HitsTableWidget.swift
//  ecommerce
//
//  Created by Guy Daher on 15/03/2017.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import Foundation

@objc public class HitsTableWidget: UITableView, UITableViewDataSource, UITableViewDelegate, HitsViewDelegate, AlgoliaView {
    
    @IBInspectable public var hitsPerPage: UInt = 20
    @IBInspectable public var infiniteScrolling: Bool = true
    @IBInspectable public var remainingItemsBeforeLoading: UInt = 5
    
    @objc public weak var hitDataSource: HitTableViewDataSource?
    @objc public weak var hitDelegate: HitTableViewDelegate?
    
    public override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        dataSource = self
        delegate = self
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        dataSource = self
        delegate = self
    }
    
    var viewModel: HitsViewModelDelegate!
    
    public func scrollTop() {
        let indexPath = IndexPath(row: 0, section: 0)
        scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    public func reloadHits() {
        reloadData()
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let hit = viewModel.hitForRow(at: indexPath)
        
        return hitDataSource?.tableView(tableView, cellForRowAt: indexPath, containing: hit) ?? UITableViewCell()
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let hit = viewModel.hitForRow(at: indexPath)
        
        hitDelegate?.tableView(tableView, didSelectRowAt: indexPath, containing: hit)
    }
}

@objc public protocol HitTableViewDataSource: class {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, containing hit: [String: Any]) -> UITableViewCell
}

@objc public protocol HitTableViewDelegate: class {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath, containing hit: [String: Any])
}
