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

class TestMultiHitsDataSource: MultiHitsDataSource {
  
  let hitsBySection: [[String]]
  
  init(hitsBySection: [[String]]) {
    self.hitsBySection = hitsBySection
  }
  
  func numberOfSections() -> Int {
    return hitsBySection.count
  }
  
  func numberOfRows(inSection section: Int) -> Int {
    return hitsBySection[section].count
  }
  
  func hitsViewModel<R>(atIndex index: Int) throws -> HitsViewModel<R> where R : Decodable, R : Encodable {
    return HitsViewModel<R>()
  }
  
}

class TableViewMultiHitsWidgetTests: XCTestCase {
  
  func testDataSource() {
    
    let hitsSource = TestMultiHitsDataSource(hitsBySection: [["t11", "t12"], ["t21", "t22", "t23"]])
    
    let dataSource = TableViewMultiHitsDataSource()
    
    dataSource.setCellConfigurator(forSection: 0) { (h: String) -> UITableViewCell in
      let cell = UITableViewCell()
      cell.textLabel?.text = h
      return cell
    }
    
    dataSource.dataSource = hitsSource
    
    let tableView = UITableView()
    
    XCTAssertEqual(dataSource.numberOfSections(in: tableView), 2)
    XCTAssertEqual(dataSource.tableView(tableView, numberOfRowsInSection: 0), 2)
    
  }
  
  func testDelegate() {
    
    let hitsSource = TestMultiHitsDataSource(hitsBySection: [["t11", "t12"], ["t21", "t22", "t23"]])
    
    let delegate = TableViewMultiHitsDelegate()
    delegate.dataSource = hitsSource
    
  }
  
  func testWidget() {

  }
  
}
