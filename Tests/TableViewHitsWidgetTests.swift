//
//  TableViewHitsWidgetTests.swift
//  InstantSearch
//
//  Created by Vladislav Fitc on 27/03/2019.
//

@testable import InstantSearch
import InstantSearchCore
import Foundation
import XCTest

class TestHitsSource: HitsSource {
  
  typealias Hit = String

  let hits: [String]
  
  init(hits: [String]) {
    self.hits = hits
  }
  
  func numberOfHits() -> Int {
    return hits.count
  }
  
  func hit(atIndex index: Int) -> String? {
    return hits[index]
  }
  
}

class TableViewHitsWidgetTests: XCTestCase {
  
  func testDataSource() {
    
    let tableView = UITableView()
    
    let dataSource = TableViewHitsDataSource<TestHitsSource> { (_, hit, _) -> UITableViewCell in
      let cell = UITableViewCell()
      cell.textLabel?.text = hit
      return cell
    }
    
    let hitsDataSource = TestHitsSource(hits: ["t1", "t2", "t3"])
    
    dataSource.hitsSource = hitsDataSource
    
    XCTAssertEqual(dataSource.tableView(tableView, numberOfRowsInSection: 0), 3)
    XCTAssertEqual(dataSource.tableView(tableView, cellForRowAt: IndexPath(row: 1, section: 0)).textLabel?.text, "t2")
    
  }
  
  func testDelegate() {
    
    let tableView = UITableView()
    
    let rowToSelect = 2
    
    let hitsDataSource = TestHitsSource(hits: ["t1", "t2", "t3"])
    
    let exp = expectation(description: "Hit selection")
    
    let delegate = TableViewHitsDelegate<TestHitsSource> { (_, hit, _) in
      XCTAssertEqual(hit, hitsDataSource.hits[rowToSelect])
      exp.fulfill()
    }

    delegate.hitsSource = hitsDataSource
    
    delegate.tableView(tableView, didSelectRowAt: IndexPath(row: rowToSelect, section: 0))
    
    waitForExpectations(timeout: 1, handler: .none)
    
  }
  
  func testWidget() {
    
    let tableView = UITableView()
    
    let vm = HitsViewModel<String>()
        
    let dataSource = TableViewHitsDataSource<HitsViewModel<String>> { (_, hit, _) -> UITableViewCell in
      let cell = UITableViewCell()
      cell.textLabel?.text = hit
      return cell
    }
    
    dataSource.hitsSource = vm
    
    let delegate = TableViewHitsDelegate<HitsViewModel<String>> { (_, _, _) in }
    
    delegate.hitsSource = vm
    
    let widget = TableViewHitsWidget<HitsViewModel<String>>(tableView: tableView)
    
    widget.dataSource = dataSource
    widget.delegate = delegate
    
    XCTAssertTrue(tableView.delegate === delegate)
    XCTAssertTrue(tableView.dataSource === dataSource)
    
  }
  
}
