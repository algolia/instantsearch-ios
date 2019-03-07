//
//  MyHitsController.swift
//  InstantSearch
//
//  Created by Vladislav Fitc on 26/02/2019.
//

import Foundation
import UIKit

protocol HitsWidget: class {
    
    associatedtype SingleHitView: UIView
    
    var viewForHit: ((Hit) -> SingleHitView)? { get set }
    var didSelectHit: ((Hit) -> Void)? { get set }
    
}

public typealias HitsViewHandler<V: UIView> = (Hit) -> V
public typealias HitsViewOnClickHandler = (Hit) -> Void

enum GenericHitsController {
    
    class TableViewHitsWidget: NSObject, HitsWidget {
        
        typealias SingleHitView = UITableViewCell
        
        let tableView: UITableView
        
        let viewModel: HitsViewModelV2
        
        var viewForHit: ((Hit) -> UITableViewCell)? {
            didSet {
                guard let viewForHit = viewForHit else {
                    self.dataSource = nil
                    return
                }
                self.dataSource = HitsTableViewDataSourceV2(hitsViewModel: viewModel, hitsTableViewCellHandler: viewForHit)
                tableView.dataSource = dataSource
            }
        }
        
        var didSelectHit: ((Hit) -> Void)? {
            didSet {
                guard let didSelectHit = didSelectHit else {
                    self.delegate = nil
                    return
                }
                self.delegate = HitsTableViewDelegateV2(hitsViewModel: viewModel, hitsTableViewOnClickHandler: didSelectHit)
                tableView.delegate = delegate
                
            }
        }
        
        private var dataSource: HitsTableViewDataSourceV2?
        private var delegate: HitsTableViewDelegateV2?
        
        init(tableView: UITableView, viewModel: HitsViewModelV2) {
            self.tableView = tableView
            self.viewModel = viewModel
        }
        
    }
    
    class CollectionViewHitsWidget: NSObject, HitsWidget {
        
        typealias SingleHitView = UICollectionViewCell
        
        let collectionView: UICollectionView
        
        let viewModel: HitsViewModelV2
        
        var viewForHit: ((Hit) -> UICollectionViewCell)? {
            didSet {
                guard let viewForHit = viewForHit else {
                    self.dataSource = nil
                    return
                }
                self.dataSource = HitsCollectionViewDataSourceV2(hitsViewModel: viewModel, hitsCollectionViewCellHandler: viewForHit)
                collectionView.dataSource = self.dataSource
            }
        }
        
        var didSelectHit: ((Hit) -> Void)? {
            didSet {
                guard let didSelectHit = didSelectHit else {
                    self.delegate = nil
                    return
                }
                self.delegate = HitsCollectionViewDelegateV2(hitsViewModel: viewModel, hitsCollectionViewOnClickHandler: didSelectHit)
                collectionView.delegate = self.delegate
            }
        }
        
        private var dataSource: HitsCollectionViewDataSourceV2?
        private var delegate: HitsCollectionViewDelegateV2?
        
        init(collectionView: UICollectionView, viewModel: HitsViewModelV2) {
            self.collectionView = collectionView
            self.viewModel = viewModel
        }
        
    }
    
    class HitsController<HV: HitsWidget>: NSObject {
        
        let viewModel: HitsViewModelV2
        weak var widget: HV?
        
        var hitsViewHandler: HitsViewHandler<HV.SingleHitView>? {
            didSet {
                widget?.viewForHit = hitsViewHandler
            }
        }
        
        var hitsViewOnClickHandler: HitsViewOnClickHandler? {
            didSet {
                widget?.didSelectHit = hitsViewOnClickHandler
            }
        }
        
        init(widget: HV, settings: HitsViewModelV2.Settings, viewModel: HitsViewModelV2) {
            self.viewModel = viewModel
            self.widget = widget
        }
        
        convenience init(widget: HV, settings: HitsViewModelV2.Settings) {
            let viewModel = HitsViewModelV2(hitsSettings: settings)
            self.init(widget: widget, settings: settings, viewModel: viewModel)
        }
        
    }
    
    typealias HitsTableViewController = HitsController<TableViewHitsWidget>
    typealias HitsCollectionViewController = HitsController<CollectionViewHitsWidget>

    class Playground {
        
        func play() {
            _ = GenericHitsController.HitsController(collectionView: UICollectionView(), settings: HitsViewModelV2.Settings())
            _ = GenericHitsController.HitsController(tableView: UITableView(), settings: HitsViewModelV2.Settings())
        }
        
    }
    
}

extension GenericHitsController.HitsController where HV == GenericHitsController.TableViewHitsWidget {
    
    convenience init(tableView: UITableView, settings: HitsViewModelV2.Settings) {
        let viewModel = HitsViewModelV2(hitsSettings: settings)
        let widget = GenericHitsController.TableViewHitsWidget(tableView: tableView, viewModel: viewModel)
        self.init(widget: widget, settings: settings, viewModel: viewModel)
    }
    
}

extension GenericHitsController.HitsController where HV == GenericHitsController.CollectionViewHitsWidget {
    
    convenience init(collectionView: UICollectionView, settings: HitsViewModelV2.Settings) {
        let viewModel = HitsViewModelV2(hitsSettings: settings)
        let widget = GenericHitsController.CollectionViewHitsWidget(collectionView: collectionView, viewModel: viewModel)
        self.init(widget: widget, settings: settings, viewModel: viewModel)
    }
    
}
