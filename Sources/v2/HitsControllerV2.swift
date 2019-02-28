//
//  HitsControllerV2.swift
//  InstantSearch
//
//  Created by Guy Daher on 15/02/2019.
//

import Foundation
import UIKit

@objc protocol HitsWidgetV2: class {
  func reload()
}

extension UITableView: HitsWidgetV2 {
  func reload() {
    reloadData()
  }
}

extension UICollectionView: HitsWidgetV2 {
  func reload() {
    reloadData()
  }
}

@objc protocol SearchWidgetV2: class {
  func observeSearchEvents(searchHandler: SearchHandler)
}

extension UISearchBar: SearchWidgetV2 {
  func observeSearchEvents(searchHandler: SearchHandler) {

  }
}

extension UITextField: SearchWidgetV2 {
  func observeSearchEvents(searchHandler: SearchHandler) {
    self.addTarget(self, action: #selector(textFieldTextChanged), for: .editingChanged)
  }

  @objc func textFieldTextChanged(textField: UITextField) {
    // let text = textField.text
    // DISCUSSION: Somehow get it back to the searchHandler? there is always the hack of storing the thing inside the class with assoicate object.
  }

}

public typealias SearchHandler = (String) -> Void
public typealias Hit = [String: Any] // could also be strongly typed if we use the power of generics
public typealias HitsTableViewCellHandler = (Hit) -> UITableViewCell
public typealias HitsCollectionViewCellHandler = (Hit) -> UICollectionViewCell
public typealias HitsTableViewOnClickHandler = (Hit) -> Void
public typealias HitsCollectionViewOnClickHandler = (Hit) -> Void

class HitsControllerV2 {

  let hitsViewModel: HitsViewModelV2
  let searchViewModel: SearchViewModelV2
  weak var hitsWidget: HitsWidgetV2?
  let index: Index
  let query: Query

  var hitsTableViewDataSource: HitsTableViewDataSourceV2?
  var hitsTableViewDelegate: HitsTableViewDelegateV2?
  var hitsCollectionViewDataSource: HitsCollectionViewDataSourceV2?
  var hitsCollectionViewDelegate: HitsCollectionViewDelegateV2?
  private var observations: [NSKeyValueObservation] = []

  // DISCUSSION: it s confusing to have hitsPerPage not in hitsSettings for the dev, although one is at the query level, the other at the viewModel level.
  public init(index: Index, query: Query, hitsWidget: HitsWidgetV2, hitsSettings: HitsSettings? = nil, querySettings: QuerySettings? = nil) {

    self.index = index
    self.query = query
    self.hitsViewModel = HitsViewModelV2(hitsSettings: hitsSettings)
    self.searchViewModel = SearchViewModelV2()
    self.hitsWidget = hitsWidget
    query.hitsPerPage = querySettings?.hitsPerPage

    // Discussion: if we can't easily have clean searchWidgets where we can observe new query changes, then the controller might have to just have methods to link
    // to UITextField, UISearchBar and custom delegate.

    let observation = query.observe(\.query, changeHandler: { [unowned self] (query, _) in
      self.query.page = 0 // When query changes and we execute a new search, we want to get back to page 0
      self.searchViewModel.search(index: index, query, completionHandler: { (result, _) in
        switch result {
        case .success(let result):
          self.hitsViewModel.update(result) // Discussion: first way to update result of the hitsViewModel
        case .fail: // TODO: Decide where we do the error handling. 
          break
        }

        self.hitsWidget?.reload()
      })
    })
    observations.append(observation)

    // TODO: do the same for reacting to filterBuilder changes, and just launching new searches.

    // DISCUSSION: concerning unowned: the controller owns the viewmodel, so if it is deallocated, then viewmodel is deallocated so this should not be called
    hitsViewModel.searchPageObservations.append { [weak self] page in
        guard let strongSelf = self else { return }
        query.page = page
        
        strongSelf.searchViewModel.search(index: index, query, completionHandler: { (result, _) in
//            strongSelf.hitsViewModel.update(result) // Discussion: Second way to update the result of the hitsViewModel Decision: Remove the closure method.
            strongSelf.hitsWidget?.reload()
        })

    }


    func setupDataSourceForTableView(_ tableView: UITableView, with hitsTableViewCellHandler: @escaping HitsTableViewCellHandler) {
      hitsTableViewDataSource = HitsTableViewDataSourceV2(hitsViewModel: hitsViewModel, hitsTableViewCellHandler: hitsTableViewCellHandler)
      tableView.dataSource = hitsTableViewDataSource
    }

    func setupDelegateForTableView(_ tableView: UITableView, with hitsTableViewOnClickHandler: @escaping HitsTableViewOnClickHandler) {
      hitsTableViewDelegate = HitsTableViewDelegateV2(hitsViewModel: hitsViewModel, hitsTableViewOnClickHandler: hitsTableViewOnClickHandler)
      tableView.delegate = hitsTableViewDelegate
    }

    func setupDataSourceForCollectionView(_ collectionView: UICollectionView, with hitsCollectionViewCellHandler: @escaping HitsCollectionViewCellHandler) {
      hitsCollectionViewDataSource = HitsCollectionViewDataSourceV2(hitsViewModel: hitsViewModel, hitsCollectionViewCellHandler: hitsCollectionViewCellHandler)
      collectionView.dataSource = hitsCollectionViewDataSource
    }

    func setupDelegateForCollectionView(_ collectionView: UICollectionView, with hitsCollectionViewOnClickHandler: @escaping HitsCollectionViewOnClickHandler) {
      hitsCollectionViewDelegate = HitsCollectionViewDelegateV2(hitsViewModel: hitsViewModel, hitsCollectionViewOnClickHandler: hitsCollectionViewOnClickHandler)
      collectionView.delegate = hitsCollectionViewDelegate
    }
  }
}

public struct QuerySettings {
  public var hitsPerPage: UInt?
}

// TODO: Add more methods such as viewForNoResults etc.. for both TableView and CollectionView.
class HitsCollectionViewDataSourceV2: NSObject, UICollectionViewDataSource {

  var hitsCollectionViewCellHandler: HitsCollectionViewCellHandler
  var hitsViewModel: HitsViewModelV2

  init(hitsViewModel: HitsViewModelV2, hitsCollectionViewCellHandler: @escaping HitsCollectionViewCellHandler) {
    self.hitsCollectionViewCellHandler = hitsCollectionViewCellHandler
    self.hitsViewModel = hitsViewModel
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let hit = hitsViewModel.hitForRow(at: indexPath)

    return hitsCollectionViewCellHandler(hit)
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return hitsViewModel.numberOfRows()
  }

}

class HitsCollectionViewDelegateV2: NSObject, UICollectionViewDelegate {

  var hitsCollectionViewOnClickHandler: HitsCollectionViewOnClickHandler
  var hitsViewModel: HitsViewModelV2

  init(hitsViewModel: HitsViewModelV2, hitsCollectionViewOnClickHandler: @escaping HitsCollectionViewOnClickHandler) {
    self.hitsCollectionViewOnClickHandler = hitsCollectionViewOnClickHandler
    self.hitsViewModel = hitsViewModel
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let hit = hitsViewModel.hitForRow(at: indexPath)

    hitsCollectionViewOnClickHandler(hit)
  }
}

class HitsTableViewDataSourceV2: NSObject, UITableViewDataSource {

  var hitsTableViewCellHandler: HitsTableViewCellHandler
  var hitsViewModel: HitsViewModelV2

  init(hitsViewModel: HitsViewModelV2, hitsTableViewCellHandler: @escaping HitsTableViewCellHandler) {
    self.hitsTableViewCellHandler = hitsTableViewCellHandler
    self.hitsViewModel = hitsViewModel
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return hitsViewModel.numberOfRows()
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let hit = hitsViewModel.hitForRow(at: indexPath)

    return hitsTableViewCellHandler(hit)
  }

}

class HitsTableViewDelegateV2: NSObject, UITableViewDelegate {

  var hitsTableViewOnClickHandler: HitsTableViewOnClickHandler
  var hitsViewModel: HitsViewModelV2

  init(hitsViewModel: HitsViewModelV2, hitsTableViewOnClickHandler: @escaping HitsTableViewOnClickHandler) {
    self.hitsTableViewOnClickHandler = hitsTableViewOnClickHandler
    self.hitsViewModel = hitsViewModel
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let hit = hitsViewModel.hitForRow(at: indexPath)

    hitsTableViewOnClickHandler(hit)
  }

}
