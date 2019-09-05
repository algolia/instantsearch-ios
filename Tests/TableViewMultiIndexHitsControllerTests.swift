//
//  TableViewMultiHitsWidgetTests.swift
//  InstantSearch
//
//  Created by Vladislav Fitc on 27/03/2019.
//

@testable import InstantSearch
import InstantSearchCore
import Foundation
import XCTest

class TableViewMultiIndexHitsControllerTests: XCTestCase {
  
  func testDataSource() {
    
    let hitsSource = TestMultiHitsDataSource(hitsBySection: [["t11", "t12"], ["t21", "t22", "t23"]])
    
    let dataSource = MultiIndexHitsTableViewDataSource()
    
    dataSource.setCellConfigurator(forSection: 0) { (_, h: String, _) -> UITableViewCell in
      let cell = UITableViewCell()
      cell.textLabel?.text = h
      return cell
    }
    
    dataSource.hitsSource = hitsSource
    
    let tableView = UITableView()
    
    XCTAssertEqual(dataSource.numberOfSections(in: tableView), 2)
    XCTAssertEqual(dataSource.tableView(tableView, numberOfRowsInSection: 0), 2)
    
  }
  
  func testDelegate() {
    
    let hitsSource = TestMultiHitsDataSource(hitsBySection: [["t11", "t12"], ["t21", "t22", "t23"]])
    
    let delegate = MultiIndexHitsTableViewDelegate()
    delegate.hitsSource = hitsSource
    
  }
  
  func testMissingHitsSource() {
    
    let tableView = UITableView()

    let dataSource = MultiIndexHitsTableViewDataSource()
    
    dataSource.setCellConfigurator(forSection: 0) { (_, h: String, _) -> UITableViewCell in
      let cell = UITableViewCell()
      cell.textLabel?.text = h
      return cell
    }
    
    let delegate = MultiIndexHitsTableViewDelegate()
    
    delegate.setClickHandler(forSection: 0) { (_, h: String, _) in
    }

    expectFatalError(expectedMessage: "Missing hits source") {
      _ = dataSource.numberOfSections(in: tableView)
    }
    
    expectFatalError(expectedMessage: "Missing hits source") {
      _ = dataSource.tableView(tableView, numberOfRowsInSection: 0)
    }
    
    expectFatalError(expectedMessage: "Missing hits source") {
      _ = dataSource.tableView(tableView, cellForRowAt: IndexPath(item: 0, section: 0))
    }
    
    expectFatalError(expectedMessage: "Missing hits source") {
      delegate.tableView(tableView, didSelectRowAt: IndexPath(item: 0, section: 0))
    }
    
  }
  
  
  func testMissingCellHandler() {
    
    let tableView = UITableView()
    
    let dataSource = MultiIndexHitsTableViewDataSource()
    
    let hitsSource = TestMultiHitsDataSource(hitsBySection: [["t11", "t12"], ["t21", "t22", "t23"]])
    
    dataSource.hitsSource = hitsSource
    
    expectFatalError(expectedMessage: "No cell configurator found for section 0") {
      _ = dataSource.tableView(tableView, cellForRowAt: IndexPath(item: 0, section: 0))
    }
    
  }
  
  func testMissingClickHandler() {
    
    let tableView = UITableView()
    
    let delegate = MultiIndexHitsTableViewDelegate()

    let hitsSource = TestMultiHitsDataSource(hitsBySection: [["t11", "t12"], ["t21", "t22", "t23"]])

    delegate.hitsSource = hitsSource
    
    expectFatalError(expectedMessage: "No click handler found for section 0") {
      _ = delegate.tableView(tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
    }
    
  }
  
}
