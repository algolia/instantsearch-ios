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

class TestHitsDataSource: HitsDataSource {
  
  typealias Hit = String

  let hits: [String]
  
  init(hits: [String]) {
    self.hits = hits
  }
  
  func numberOfRows() -> Int {
    return hits.count
  }
  
  func hitForRow(atIndex rowIndex: Int) -> String? {
    return hits[rowIndex]
  }
  
}

class TableViewHitsWidgetTests: XCTestCase {
  
  func testDataSource() {
    
    let tableView = UITableView()
    
    let dataSource = TableViewHitsDataSource<TestHitsDataSource> { hit -> UITableViewCell in
      let cell = UITableViewCell()
      cell.textLabel?.text = hit
      return cell
    }
    
    let hitsDataSource = TestHitsDataSource(hits: ["t1", "t2", "t3"])
    
    dataSource.dataSource = hitsDataSource
    
    XCTAssertEqual(dataSource.tableView(tableView, numberOfRowsInSection: 0), 3)
    XCTAssertEqual(dataSource.tableView(tableView, cellForRowAt: IndexPath(row: 1, section: 0)).textLabel?.text, "t2")
    
  }
  
  func testDelegate() {
    
    let tableView = UITableView()
    
    let rowToSelect = 2
    
    let hitsDataSource = TestHitsDataSource(hits: ["t1", "t2", "t3"])
    
    let exp = expectation(description: "Hit selection")
    
    let delegate = TableViewHitsDelegate<TestHitsDataSource> { hit in
      XCTAssertEqual(hit, hitsDataSource.hits[rowToSelect])
      exp.fulfill()
    }

    delegate.dataSource = hitsDataSource
    
    delegate.tableView(tableView, didSelectRowAt: IndexPath(row: rowToSelect, section: 0))
    
    waitForExpectations(timeout: 1, handler: .none)
    
  }
  
  func testWidget() {
    
    let tableView = UITableView()
    
    let vm = HitsViewModel<String>()
        
    let dataSource = TableViewHitsDataSource<HitsViewModel<String>> { hit -> UITableViewCell in
      let cell = UITableViewCell()
      cell.textLabel?.text = hit
      return cell
    }
    
    dataSource.dataSource = vm
    
    let delegate = TableViewHitsDelegate<HitsViewModel<String>> { _ in }
    
    delegate.dataSource = vm
    
    let widget = TableViewHitsWidget<String>(tableView: tableView)
    
    widget.dataSource = dataSource
    widget.delegate = delegate
    
    XCTAssertTrue(tableView.delegate === delegate)
    XCTAssertTrue(tableView.dataSource === dataSource)
    
  }
  
}
