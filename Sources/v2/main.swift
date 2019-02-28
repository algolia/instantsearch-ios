//
//  main.swift
//  InstantSearch
//
//  Created by Guy Daher on 26/02/2019.
//

import Foundation
import UIKit

class Main: UIViewController, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate {

  let hitsViewModel = HitsViewModelV2()
  let refinementViewModel = RefinementMenuViewModel()
  let textField = UITextField()
  let hitsView = UITableView()
  let refinementView = UICollectionView()
  var searcher: SingleIndexSearcher!

  override func viewDidLoad() {
    hitsView.dataSource = self
    refinementView.dataSource = self
    refinementView.delegate = self

    let textFieldWidget = TextFieldWidgetV2(textField: textField)

    let client = Client(appID: "", apiKey: "")
    let index = client.index(withName: "")
    let query = Query()

    searcher = SingleIndexSearcher(index: index, query: query)

    textFieldWidget.subscribeToTextChangeHandler { (text) in
      self.searcher.query.query = text
      self.searcher.search()
    }

    self.searcher.subscribeToSearchResults { (result) in
      switch result {
      case .success(let result): self.hitsViewModel.update(result)
      case .fail(let error): // TODO: Do something with error
        break
      }

      self.hitsView.reload()
    }

    self.hitsViewModel.subscribePageReload { (page) in
      self.searcher.query.page = UInt(page)
      self.searcher.search()
    }
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let refinement = refinementViewModel.facetForRow(at: indexPath)
    searcher.query.query = refinement.value // Modify filter with filterBuilder
    self.searcher.search()
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return hitsViewModel.numberOfRows()
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "", for: indexPath)
    let hit = hitsViewModel.hitForRow(at: indexPath)
    cell.textLabel?.text = hit["name"] as? String

    return cell
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "", for: indexPath)
      _ = refinementViewModel.facetForRow(at: indexPath)
      cell.backgroundColor = .red
      return cell
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return refinementViewModel.numberOfRows()
  }
}

//class Main2: UIViewController, UITableViewDataSource {
//
//  let hitsViewModel = Array(repeating: HitsViewModelV2(infiniteScrolling: false), count: 3)
//  let textField = UITextField()
//  let hitsView = UITableView()
//  var searcher: MultiIndexSearcher!
//  var client: Client!
//
//  override func viewDidLoad() {
//    hitsView.dataSource = self
//
//    let textFieldWidget = TextFieldWidgetV2(textField: textField)
//
//    client = Client(appID: "", apiKey: "")
//    let songsIndex = client.index(withName: "songs")
//    let artistsIndex = client.index(withName: "artists")
//    let albumsIndex = client.index(withName: "albums")
//    let query = Query()
//
//
//    searcher = MultiIndexSearcher(client: client, indexQueries: <#T##[IndexQuery]#>)
//    searcher = SingleIndexSearcher(index: index, query: query)
//
//    textFieldWidget.subscribeToTextChangeHandler { (text) in
//      self.searcher.query.query = text
//      self.searcher.search()
//    }
//
//    self.searcher.subscribeToSearchResults { (result) in
//      switch result {
//      case .success(let result): self.hitsViewModel.update(result)
//      case .fail(let error): // TODO: Do something with error
//        break
//      }
//
//      self.hitsView.reload()
//    }
//
//    self.hitsViewModel.subscribePageReload { (page) in
//      self.searcher.query.page = UInt(page)
//      self.searcher.search()
//    }
//  }
//
//  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//    <#code#>
//  }
//
//  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//    <#code#>
//  }
//}

// Using controllers
class Main3: UIViewController {

  override func viewDidLoad() {
    let tableView = UITableView()
    let hitsController = GenericHitsController.HitsTableViewController(tableView: tableView, settings: HitsSettings())
    hitsController.hitsViewHandler = { hit in
      // TODO: pass in the indexpath? Or he can specify identifier in the init, and we can just create it for him.
      let cell = tableView.dequeueReusableCell(withIdentifier: "", for: IndexPath(row: 0, section: 0))
      cell.textLabel?.text = hit["name"] as? String
      return cell
    }
  }

}
