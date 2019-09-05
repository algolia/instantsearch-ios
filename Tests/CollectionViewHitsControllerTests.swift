//
//  CollectionViewHitsControllerTests.swift
//  InstantSearchTests
//
//  Created by Vladislav Fitc on 04/09/2019.
//

@testable import InstantSearch
import Foundation
import XCTest


class TestTemplateCollectionViewCell: UICollectionViewCell {}

class CollectionViewHitsControllerTests: XCTestCase {
  
  func testMissingDataSource() {
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    let dataSource = HitsCollectionViewDataSource<TestHitsSource> { (_, hit, _) in
      let cell = TestCollectionViewCell()
      cell.content = hit
      return cell
    }
    
    expectFatalError(expectedMessage: "Missing hits source") {
      _ = dataSource.collectionView(collectionView, cellForItemAt: .init())
    }
    
    expectFatalError(expectedMessage: "Missing hits source") {
      _ = dataSource.collectionView(collectionView, numberOfItemsInSection: .init())
    }
    
    let delegate = HitsCollectionViewDelegate<TestHitsSource> { _,_,_  in }
    
    expectFatalError(expectedMessage: "Missing hits source") {
      _ = delegate.collectionView(collectionView, didSelectItemAt: .init())
    }
    
  }
  
  func testTemplate() {
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

    let hitsDataSource = TestHitsSource(hits: ["t1", "t2", "t3"])
    
    let dataSource = HitsCollectionViewDataSource<TestHitsSource> { (_, hit, _) -> UICollectionViewCell in
      let cell = TestCollectionViewCell()
      cell.content = hit
      return cell
    }
    
    dataSource.hitsSource = hitsDataSource
    
    dataSource.templateCellProvider = { return TestTemplateCollectionViewCell() }
    
    XCTAssert(dataSource.collectionView(collectionView, cellForItemAt: IndexPath(item: 4, section: 0)) is TestTemplateCollectionViewCell, "")
    
  }
  
  func testDataSource() {
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

    let dataSource = HitsCollectionViewDataSource<TestHitsSource> { (_, hit, _) -> UICollectionViewCell in
      let cell = TestCollectionViewCell()
      cell.content = hit
      return cell
    }
    
    let hitsDataSource = TestHitsSource(hits: ["t1", "t2", "t3"])
    
    dataSource.hitsSource = hitsDataSource
    
    XCTAssertEqual(dataSource.collectionView(collectionView, numberOfItemsInSection: 0), 3)
    XCTAssertEqual((dataSource.collectionView(collectionView, cellForItemAt: IndexPath(item: 1, section: 0)) as? TestCollectionViewCell)?.content, "t2")
    
  }
  
  func testDelegate() {
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

    let itemToSelect = 2
    
    let hitsDataSource = TestHitsSource(hits: ["t1", "t2", "t3"])
    
    let exp = expectation(description: "Hit selection")
    
    let delegate = HitsCollectionViewDelegate<TestHitsSource> { (_, hit, _) in
      XCTAssertEqual(hit, hitsDataSource.hits[itemToSelect])
      exp.fulfill()
    }
    
    delegate.hitsSource = hitsDataSource
    
    delegate.collectionView(collectionView, didSelectItemAt: IndexPath(item: itemToSelect, section: 0))
    
    waitForExpectations(timeout: 1, handler: .none)
    
  }
  
  func testWidget() {
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

    let vm = HitsInteractor<String>()
    
    let dataSource = HitsCollectionViewDataSource<HitsInteractor<String>> { (_, hit, _) -> UICollectionViewCell in
      let cell = TestCollectionViewCell()
      cell.content = hit
      return cell
    }
    
    dataSource.hitsSource = vm
    
    let delegate = HitsCollectionViewDelegate<HitsInteractor<String>> { (_, _, _) in }
    
    delegate.hitsSource = vm
    
    let widget = HitsCollectionController<HitsInteractor<String>>(collectionView: collectionView)
    
    widget.dataSource = dataSource
    widget.delegate = delegate
    
    XCTAssertTrue(collectionView.delegate === delegate)
    XCTAssertTrue(collectionView.dataSource === dataSource)
    
  }
  
}
