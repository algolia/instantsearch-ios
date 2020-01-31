//
//  TableViewHitsControllerTests.swift
//  InstantSearch
//
//  Created by Vladislav Fitc on 27/03/2019.
//

@testable import InstantSearch
import InstantSearchCore
import Foundation
import XCTest

class TestTemplateCell: UITableViewCell {}

class TableViewHitsControllerTests: XCTestCase {
  
  func testMissingDataSource() {
    
    let tableView = UITableView()
    
    let dataSource = HitsTableViewDataSource<TestHitsSource> { (_, hit, _) -> UITableViewCell in
      let cell = UITableViewCell()
      cell.textLabel?.text = hit
      return cell
    }
    
    
    expectLog(expectedMessage: "Missing hits source", expectedLevel: .warning) {
      _ = dataSource.tableView(tableView, cellForRowAt: .init())
    }
    
    expectLog(expectedMessage: "Missing hits source", expectedLevel: .warning) {
      _ = dataSource.tableView(tableView, numberOfRowsInSection: .init())
    }
    
    let delegate = HitsTableViewDelegate<TestHitsSource> { _,_,_  in }
    
    expectLog(expectedMessage: "Missing hits source", expectedLevel: .warning) {
      _ = delegate.tableView(tableView, didSelectRowAt: .init())
    }
    
  }
  
  func testTemplate() {
    
    let tableView = UITableView()
    
    let hitsDataSource = TestHitsSource(hits: ["t1", "t2", "t3"])
    
    let dataSource = HitsTableViewDataSource<TestHitsSource> { (_, hit, _) -> UITableViewCell in
      let cell = UITableViewCell()
      cell.textLabel?.text = hit
      return cell
    }
    
    dataSource.hitsSource = hitsDataSource
    
    dataSource.templateCellProvider = { return TestTemplateCell() }

    XCTAssert(dataSource.tableView(tableView, cellForRowAt: IndexPath(row: 4, section: 0)) is TestTemplateCell, "")
    
  }
  
  func testDataSource() {
    
    let tableView = UITableView()
    
    let dataSource = HitsTableViewDataSource<TestHitsSource> { (_, hit, _) -> UITableViewCell in
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
    
    let delegate = HitsTableViewDelegate<TestHitsSource> { (_, hit, _) in
      XCTAssertEqual(hit, hitsDataSource.hits[rowToSelect])
      exp.fulfill()
    }

    delegate.hitsSource = hitsDataSource
    
    delegate.tableView(tableView, didSelectRowAt: IndexPath(row: rowToSelect, section: 0))
    
    waitForExpectations(timeout: 1, handler: .none)
    
  }
  
  func testWidget() {
    
    let tableView = UITableView()
    
    let vm = HitsInteractor<String>()
        
    let dataSource = HitsTableViewDataSource<HitsInteractor<String>> { (_, hit, _) -> UITableViewCell in
      let cell = UITableViewCell()
      cell.textLabel?.text = hit
      return cell
    }
    
    dataSource.hitsSource = vm
    
    let delegate = HitsTableViewDelegate<HitsInteractor<String>> { (_, _, _) in }
    
    delegate.hitsSource = vm
    
    let widget = HitsTableController<HitsInteractor<String>>(tableView: tableView)
    
    widget.dataSource = dataSource
    widget.delegate = delegate
    
    XCTAssertTrue(tableView.delegate === delegate)
    XCTAssertTrue(tableView.dataSource === dataSource)
    
  }
  
}
