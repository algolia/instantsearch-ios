//
//  FilterStateTests.swift
//  AlgoliaSearch
//
//  Created by Guy Daher on 10/12/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import Foundation

@testable import InstantSearchCore
import XCTest

extension FilterGroupsConvertible {

  func buildSQL() -> String? {
    return FilterGroupConverter().sql(toFilterGroups())
  }

}

class FilterStateTests: XCTestCase {

  override func setUp() {
    super.setUp()
  }

  override func tearDown() {
    super.tearDown()
  }

  func testPlayground() {

    var filterState = GroupsStorage()
    let filterFacet1 = Filter.Facet(attribute: "category", value: "table")
    let filterFacet2 = Filter.Facet(attribute: "category", value: "chair")
    let filterNumeric1 = Filter.Numeric(attribute: "price", operator: .greaterThan, value: 10)
    let filterNumeric2 = Filter.Numeric(attribute: "price", operator: .lessThan, value: 20)
    let filterTag1 = Filter.Tag(value: "Tom")
    let filterTag2 = Filter.Tag(value: "Hank")

    let groupFacets = FilterGroup.ID.or(name: "filterFacets", filterType: .facet)
    let groupFacetsOtherInstance = FilterGroup.ID.or(name: "filterFacets", filterType: .facet)
    let groupNumerics = FilterGroup.ID.and(name: "filterNumerics")
    let groupTagsOr = FilterGroup.ID.or(name: "filterTags", filterType: .tag)
    let groupTagsAnd = FilterGroup.ID.and(name: "filterTags")

    filterState.add(filterFacet1, toGroupWithID: groupFacets)
    // Make sure that if we re-create a group instance, filters will stay in same group bracket
    filterState.add(filterFacet2, toGroupWithID: groupFacetsOtherInstance)

    filterState.add(filterNumeric1, toGroupWithID: groupNumerics)
    filterState.add(filterNumeric2, toGroupWithID: groupNumerics)
    // Repeat once to see if the Set rejects same filter
    filterState.add(filterNumeric2, toGroupWithID: groupNumerics)

    filterState.addAll(filters: [filterTag1, filterTag2], toGroupWithID: groupTagsOr)
    filterState.add(filterTag1, toGroupWithID: groupTagsAnd)
    let expectedState = """
( "category":"chair" OR "category":"table" ) AND ( "price" < 20.0 AND "price" > 10.0 ) AND ( "_tags":"Hank" OR "_tags":"Tom" ) AND ( "_tags":"Tom" )
"""
    XCTAssertEqual(filterState.buildSQL(), expectedState)

    XCTAssertTrue(filterState.contains(filterFacet1))

    let missingFilter = Filter.Facet(attribute: "bla", value: false)
    XCTAssertFalse(filterState.contains(missingFilter))

    filterState.remove(filterTag1, fromGroupWithID: groupTagsAnd) // existing one
    filterState.remove(filterTag1, fromGroupWithID: groupTagsAnd) // remove one more time
    filterState.remove(Filter.Tag(value: "unexisting"), fromGroupWithID: groupTagsOr) // remove one that does not exist
    filterState.remove(filterFacet1) // Remove in all groups

    let expectedFilterState2 = """
                                    ( "category":"chair" ) AND ( "price" < 20.0 AND "price" > 10.0 ) AND ( "_tags":"Hank" OR "_tags":"Tom" )
                                    """
    XCTAssertEqual(filterState.buildSQL(), expectedFilterState2)

    filterState.removeAll([filterNumeric1, filterNumeric2])

    let expectedFilterState3 = """
                                    ( "category":"chair" ) AND ( "_tags":"Hank" OR "_tags":"Tom" )
                                    """
    XCTAssertEqual(filterState.buildSQL(), expectedFilterState3)

  }

  func testInversion() {

    var filterState = GroupsStorage()

    filterState.addAll(filters: [
      Filter.Tag(value: "tagA", isNegated: true),
      Filter.Tag(value: "tagB", isNegated: true)], toGroupWithID: .or(name: "a", filterType: .tag))

    filterState.addAll(filters: [
      Filter.Facet(attribute: "size", value: 40, isNegated: true),
      Filter.Facet(attribute: "featured", value: true, isNegated: true)
    ], toGroupWithID: .or(name: "b", filterType: .facet))

    let expectedState = "( NOT \"_tags\":\"tagA\" OR NOT \"_tags\":\"tagB\" ) AND ( NOT \"featured\":\"true\" OR NOT \"size\":\"40.0\" )"

    XCTAssertEqual(filterState.buildSQL(), expectedState)

  }

  func testCopyConstructor() {

    let filterState = FilterState()

    filterState[and: "a"].add(Filter.Facet(attribute: "f1", boolValue: true), Filter.Numeric(attribute: "f2", range: 0...10))
    filterState[or: "b"].add(Filter.Tag(value: "t1"), Filter.Tag(value: "t2"))
    filterState[hierarchical: "c"].add(.init(attribute: "f", stringValue: "test"))

    let filterStateCopy = FilterState(filterState)

    XCTAssert(filterStateCopy[and: "a"].contains(Filter.Facet(attribute: "f1", boolValue: true)))
    XCTAssert(filterStateCopy[and: "a"].contains(Filter.Numeric(attribute: "f2", range: 0...10)))
    XCTAssert(filterStateCopy[or: "b"].contains(Filter.Tag(value: "t1")))
    XCTAssert(filterStateCopy[or: "b"].contains(Filter.Tag(value: "t2")))
    XCTAssert(filterStateCopy[hierarchical: "c"].contains(.init(attribute: "f", stringValue: "test")))

  }

  func testSetWithContent() {

    let filterState = FilterState()

    filterState[and: "a"].add(Filter.Facet(attribute: "f1", boolValue: true), Filter.Numeric(attribute: "f2", range: 0...10))
    filterState[or: "b"].add(Filter.Tag(value: "t1"), Filter.Tag(value: "t2"))
    filterState[hierarchical: "c"].add(.init(attribute: "f", stringValue: "test"))

    let anotherFilterState = FilterState()
    anotherFilterState.setWithContent(of: filterState)

    XCTAssert(anotherFilterState[and: "a"].contains(Filter.Facet(attribute: "f1", boolValue: true)))
    XCTAssert(anotherFilterState[and: "a"].contains(Filter.Numeric(attribute: "f2", range: 0...10)))
    XCTAssert(anotherFilterState[or: "b"].contains(Filter.Tag(value: "t1")))
    XCTAssert(anotherFilterState[or: "b"].contains(Filter.Tag(value: "t2")))
    XCTAssert(anotherFilterState[hierarchical: "c"].contains(.init(attribute: "f", stringValue: "test")))

  }

  func testAdd() {

    var filterState = GroupsStorage()

    let filterFacet1 = Filter.Facet(attribute: Attribute("category"), value: "table")
    let filterFacet2 = Filter.Facet(attribute: Attribute("category"), value: "chair")
    let filterNumeric1 = Filter.Numeric(attribute: "price", operator: .greaterThan, value: 10)
    let filterNumeric2 = Filter.Numeric(attribute: "price", operator: .lessThan, value: 20)
    let filterTag1 = Filter.Tag(value: "Tom")
    let filterTag2 = Filter.Tag(value: "Hank")

    let groupFacets: FilterGroup.ID = .or(name: "filterFacets", filterType: .facet)
    let groupFacetsOtherInstance: FilterGroup.ID = .or(name: "filterFacets", filterType: .facet)
    let groupNumerics: FilterGroup.ID = .and(name: "filterNumerics")
    let groupTagsOr: FilterGroup.ID = .or(name: "filterTags", filterType: .tag)
    let groupTagsAnd: FilterGroup.ID = .and(name: "filterTags")

    filterState.add(filterFacet1, toGroupWithID: groupFacets)
    // Make sure that if we re-create a group instance, filters will stay in same group bracket
    filterState.add(filterFacet2, toGroupWithID: groupFacetsOtherInstance)

    filterState.add(filterNumeric1, toGroupWithID: groupNumerics)
    filterState.add(filterNumeric2, toGroupWithID: groupNumerics)
    // Repeat once to see if the Set rejects same filter
    filterState.add(filterNumeric2, toGroupWithID: groupNumerics)

    filterState.addAll(filters: [filterTag1, filterTag2], toGroupWithID: groupTagsOr)
    filterState.add(filterTag1, toGroupWithID: groupTagsAnd)

    let expectedState = """
                                    ( "category":"chair" OR "category":"table" ) AND ( "price" < 20.0 AND "price" > 10.0 ) AND ( "_tags":"Hank" OR "_tags":"Tom" ) AND ( "_tags":"Tom" )
                                    """

    XCTAssertEqual(filterState.buildSQL(), expectedState)

  }

  func testContains() {

    var filterState = GroupsStorage()

    let tagA = Filter.Tag(value: "A")
    let tagB = Filter.Tag(value: "B")
    let tagC = Filter.Tag(value: "C")
    let numeric = Filter.Numeric(attribute: "price", operator: .lessThan, value: 100)
    let facet = Filter.Facet(attribute: "new", value: true)

    filterState.addAll(filters: [tagA, tagB], toGroupWithID: .or(name: "tags", filterType: .tag))

    filterState.addAll(filters: [Filter.Tag(value: "hm"), Filter.Tag(value: "other")], toGroupWithID: .or(name: "tags", filterType: .tag))

    filterState.addAll(filters: [
      Filter.Numeric(attribute: "size", range: 15...20),
      Filter.Numeric(attribute: "price", operator: .greaterThan, value: 100)], toGroupWithID: .or(name: "numeric", filterType: .numeric))

    filterState.add(numeric, toGroupWithID: .and(name: "others"))
    filterState.add(facet, toGroupWithID: .and(name: "others"))
    filterState.add(Filter.Tag(value: "someTag"), toGroupWithID: .and(name: "some"))
    filterState.addAll(filters: [
      Filter.Numeric(attribute: "price", operator: .greaterThan, value: 20),
      Filter.Numeric(attribute: "size", range: 15...20)
    ], toGroupWithID: .and(name: "some"))
    filterState.addAll(filters: [
      Filter.Facet(attribute: "brand", stringValue: "apple"),
      Filter.Facet(attribute: "featured", boolValue: true),
      Filter.Facet(attribute: "rating", floatValue: 4)
    ], toGroupWithID: .and(name: "some"))

    XCTAssertTrue(filterState.contains(tagA))
    XCTAssertTrue(filterState.contains(tagB))
    XCTAssertTrue(filterState.contains(numeric))
    XCTAssertTrue(filterState.contains(facet))
    XCTAssertTrue(filterState.contains(tagA, inGroupWithID: .or(name: "tags", filterType: .tag)))
    XCTAssertTrue(filterState.contains(tagB, inGroupWithID: .or(name: "tags", filterType: .tag)))
    XCTAssertTrue(filterState.contains(numeric, inGroupWithID: .and(name: "others")))
    XCTAssertTrue(filterState.contains(facet, inGroupWithID: .and(name: "others")))

    XCTAssertFalse(filterState.contains(tagC))
    XCTAssertFalse(filterState.contains(Filter.Facet(attribute: "new", value: false)))
    XCTAssertFalse(filterState.contains(tagC, inGroupWithID: .or(name: "tags", filterType: .tag)))
    XCTAssertFalse(filterState.contains(tagA, inGroupWithID: .and(name: "others")))
    XCTAssertFalse(filterState.contains(tagB, inGroupWithID: .and(name: "others")))

    let expectedResult = """
        ( "price" > 100.0 OR "size":15.0 TO 20.0 ) AND ( "new":"true" AND "price" < 100.0 ) AND ( "_tags":"someTag" AND "brand":"apple" AND "featured":"true" AND "price" > 20.0 AND "rating":"4.0" AND "size":15.0 TO 20.0 ) AND ( "_tags":"A" OR "_tags":"B" OR "_tags":"hm" OR "_tags":"other" )
        """

    XCTAssertEqual(filterState.buildSQL(), expectedResult)

  }

  func testRemove() {

    var filterState = GroupsStorage()

    let orGroupID: FilterGroup.ID = .or(name: "orTags", filterType: .tag)
    let andGroupID: FilterGroup.ID = .and(name: "any")
    let tagA = Filter.Tag(value: "a")
    let tagB = Filter.Tag(value: "b")
    let numericFilter = Filter.Numeric(attribute: "price", range: 1...10)
    filterState.addAll(filters: [tagA, tagB], toGroupWithID: orGroupID)
    filterState.addAll(filters: [tagA, tagB], toGroupWithID: andGroupID)
    filterState.add(numericFilter, toGroupWithID: andGroupID)

    XCTAssertEqual(filterState.buildSQL(), """
        ( "_tags":"a" AND "_tags":"b" AND "price":1.0 TO 10.0 ) AND ( "_tags":"a" OR "_tags":"b" )
        """)

//    XCTAssertTrue(filterState.remove(tagA, fromGroupWithID: andGroupID))
    XCTAssertTrue(filterState.remove(tagA))
    XCTAssertFalse(filterState.contains(tagA, inGroupWithID: andGroupID))

//    XCTAssertTrue(filterState.remove(tagA, fromGroupWithID: orGroupID))
    XCTAssertFalse(filterState.contains(tagA, inGroupWithID: orGroupID))

//    XCTAssertFalse(filterState.contains(Filter.Tag(value: "a"), inGroupWithID: orGroupID))
    XCTAssertFalse(filterState.contains(Filter.Tag(value: "a")))

    XCTAssertEqual(filterState.buildSQL(), """
        ( "_tags":"b" AND "price":1.0 TO 10.0 ) AND ( "_tags":"b" )
        """)

    // Try to delete one more time
    XCTAssertFalse(filterState.remove(Filter.Tag(value: "a")))

    XCTAssertEqual(filterState.buildSQL(), """
        ( "_tags":"b" AND "price":1.0 TO 10.0 ) AND ( "_tags":"b" )
        """)

    // Remove filter occuring in multiple groups from one group

    XCTAssertTrue(filterState.remove(Filter.Tag(value: "b"), fromGroupWithID: .and(name: "any")))

    XCTAssertTrue(filterState.contains(Filter.Tag(value: "b")))
    XCTAssertFalse(filterState.contains(Filter.Tag(value: "b"), inGroupWithID: .and(name: "any")))
    XCTAssertTrue(filterState.contains(Filter.Tag(value: "b"), inGroupWithID: .or(name: "orTags", filterType: .tag)))

    XCTAssertEqual(filterState.buildSQL(), """
        ( "price":1.0 TO 10.0 ) AND ( "_tags":"b" )
        """)

    // Remove all from group
    filterState.removeAll(fromGroupWithID: .and(name: "any"))
    XCTAssertTrue(filterState.getFilters(forGroupWithID: .and(name: "any")).isEmpty)

    XCTAssertEqual(filterState.buildSQL(), """
        ( "_tags":"b" )
        """)

    // Remove all anywhere
    filterState.removeAll()
    XCTAssertTrue(filterState.isEmpty)

    XCTAssertEqual(filterState.buildSQL(), nil)

  }

  func testSubscriptAndOperatorPlayground() {

    var filterState = GroupsStorage()

    let filterFacet1 = Filter.Facet(attribute: "category", value: "table")
    let filterFacet2 = Filter.Facet(attribute: "category", value: "chair")
    let filterNumeric1 = Filter.Numeric(attribute: "price", operator: .greaterThan, value: 10)
    let filterNumeric2 = Filter.Numeric(attribute: "price", operator: .lessThan, value: 20)
    let filterTag1 = Filter.Tag(value: "Tom")

    filterState.add(filterFacet1, toGroupWithID: .or(name: "a", filterType: .facet))
    filterState.remove(filterFacet2, fromGroupWithID: .or(name: "a", filterType: .facet))

    XCTAssertEqual(filterState.buildSQL(), """
        ( "category":"table" )
        """)

    filterState.add(filterNumeric1, toGroupWithID: .and(name: "b"))
    filterState.add(filterTag1, toGroupWithID: .and(name: "b"))

    XCTAssertEqual(filterState.buildSQL(), """
        ( "category":"table" ) AND ( "_tags":"Tom" AND "price" > 10.0 )
        """)

    filterState.addAll(filters: [filterFacet1, filterFacet2], toGroupWithID: .or(name:"a", filterType: .facet))

    XCTAssertEqual(filterState.buildSQL(), """
        ( "category":"chair" OR "category":"table" ) AND ( "_tags":"Tom" AND "price" > 10.0 )
        """)

    filterState.addAll(filters: [filterNumeric1, filterNumeric2], toGroupWithID: .and(name: "b"))

    XCTAssertEqual(filterState.buildSQL(), """
        ( "category":"chair" OR "category":"table" ) AND ( "_tags":"Tom" AND "price" < 20.0 AND "price" > 10.0 )
        """)

  }

  func testClearAttribute() {

    let filterNumeric1 = Filter.Numeric(attribute: "price", operator: .greaterThan, value: 10)
    let filterNumeric2 = Filter.Numeric(attribute: "price", operator: .lessThan, value: 20)
    let filterTag1 = Filter.Tag(value: "Tom")
    let filterTag2 = Filter.Tag(value: "Hank")

    let groupNumericsOr = FilterGroup.ID.or(name: "filterNumeric", filterType: .numeric)
    let groupTagsOr = FilterGroup.ID.or(name: "filterTags", filterType: .tag)

    var filterState = GroupsStorage()

    filterState.addAll(filters: [filterNumeric1, filterNumeric2], toGroupWithID: groupNumericsOr)
    XCTAssertEqual(filterState.buildSQL(), """
        ( "price" < 20.0 OR "price" > 10.0 )
        """)

    filterState.addAll(filters: [filterTag1, filterTag2], toGroupWithID: groupTagsOr)

    XCTAssertEqual(filterState.buildSQL(), """
        ( "price" < 20.0 OR "price" > 10.0 ) AND ( "_tags":"Hank" OR "_tags":"Tom" )
        """)

    filterState.removeAll(for: "price")

    XCTAssertFalse(filterState.contains(filterNumeric1))
    XCTAssertFalse(filterState.contains(filterNumeric2))
    XCTAssertTrue(filterState.contains(filterTag1))
    XCTAssertTrue(filterState.contains(filterTag2))

    XCTAssertEqual(filterState.buildSQL(), """
        ( "_tags":"Hank" OR "_tags":"Tom" )
        """)

  }

  func testIsEmpty() {
    var filterState = GroupsStorage()
    let filter = Filter.Numeric(attribute: "price", operator: .greaterThan, value: 10)
    let group = FilterGroup.ID.or(name: "group", filterType: .numeric)
    XCTAssertTrue(filterState.isEmpty)
    filterState.add(filter, toGroupWithID: group)
    XCTAssertEqual(filterState.buildSQL(), """
        ( "price" > 10.0 )
        """)
    XCTAssertFalse(filterState.isEmpty)
    filterState.remove(filter)
    XCTAssertTrue(filterState.isEmpty, filterState.buildSQL()!)
    XCTAssertEqual(filterState.buildSQL(), nil)
  }

  func testClear() {
    var filterState = GroupsStorage()
    let filterNumeric = Filter.Numeric(attribute: "price", operator: .greaterThan, value: 10)
    let filterTag = Filter.Tag(value: "Tom")
    let group = FilterGroup.ID.and(name: "group")
    filterState.add(filterNumeric, toGroupWithID: group)
    XCTAssertEqual(filterState.buildSQL(), """
        ( "price" > 10.0 )
        """)
    filterState.add(filterTag, toGroupWithID: group)
    XCTAssertEqual(filterState.buildSQL(), """
        ( "_tags":"Tom" AND "price" > 10.0 )
        """)
    filterState.removeAll()
    XCTAssertTrue(filterState.isEmpty)
    XCTAssertEqual(filterState.buildSQL(), nil)
  }

  func testToggle() {

    var filterState = GroupsStorage()

    let filter = Filter.Facet(attribute: "brand", stringValue: "sony")

    // Conjunctive Group

    XCTAssertFalse(filterState.getFilters(forGroupWithID: .or(name: "a", filterType: .facet)).contains(.facet(filter)))
    XCTAssertTrue(filterState.getFilters(forGroupWithID: .or(name: "a", filterType: .facet)).isEmpty)

    filterState.toggle(filter, inGroupWithID: .or(name: "a", filterType: .facet))
    XCTAssertTrue(filterState.getFilters(forGroupWithID: .or(name: "a", filterType: .facet)).contains(.facet(filter)))
    XCTAssertFalse(filterState.getFilters(forGroupWithID: .or(name: "a", filterType: .facet)).isEmpty)

    filterState.toggle(filter, inGroupWithID: .or(name: "a", filterType: .facet))
    XCTAssertFalse(filterState.contains(filter, inGroupWithID: .or(name: "a", filterType: .facet)))
    XCTAssertTrue(filterState.getFilters(forGroupWithID: .or(name: "a", filterType: .facet)).isEmpty)

    // Disjunctive Group

    XCTAssertFalse(filterState.contains(filter, inGroupWithID: .and(name: "a")))
    XCTAssertTrue(filterState.getFilters(forGroupWithID: .and(name: "a")).isEmpty)

    filterState.toggle(filter, inGroupWithID: .and(name: "a"))
    XCTAssertTrue(filterState.getFilters(forGroupWithID: .and(name: "a")).contains(.facet(filter)))
    XCTAssertFalse(filterState.getFilters(forGroupWithID: .and(name: "a")).isEmpty)

    filterState.toggle(filter, inGroupWithID: .and(name: "a"))
    XCTAssertFalse(filterState.contains(filter, inGroupWithID: .and(name: "a")))
    XCTAssertTrue(filterState.getFilters(forGroupWithID: .and(name: "a")).isEmpty)

    filterState.toggle(Filter.Numeric(attribute: "size", operator: .equals, value: 40), inGroupWithID: .and(name: "a"))
    filterState.toggle(Filter.Facet(attribute: "country", stringValue: "france"), inGroupWithID: .and(name: "a"))

    XCTAssertFalse(filterState.getFilters(forGroupWithID: .and(name: "a")).isEmpty)
    XCTAssertTrue(filterState.getFilters(forGroupWithID: .and(name: "a")).contains(.numeric(Filter.Numeric(attribute: "size", operator: .equals, value: 40))))
    XCTAssertTrue(filterState.getFilters(forGroupWithID: .and(name: "a")).contains(.facet(Filter.Facet(attribute: "country", stringValue: "france"))))

    filterState.toggle(Filter.Numeric(attribute: "size", operator: .equals, value: 40), inGroupWithID: .and(name: "a"))
      filterState.toggle(Filter.Facet(attribute: "country", stringValue: "france"), inGroupWithID: .and(name: "a"))

    XCTAssertTrue(filterState.getFilters(forGroupWithID: .and(name: "a")).isEmpty)
    XCTAssertFalse(filterState.getFilters(forGroupWithID: .and(name: "a")).contains(.numeric(Filter.Numeric(attribute: "size", operator: .equals, value: 40))))
    XCTAssertFalse(filterState.getFilters(forGroupWithID: .and(name: "a")).contains(.facet(Filter.Facet(attribute: "country", stringValue: "france"))))

    filterState.toggle(Filter.Facet(attribute: "size", floatValue: 40), inGroupWithID: .or(name: "a", filterType: .facet))
    filterState.toggle(Filter.Facet(attribute: "count", floatValue: 25), inGroupWithID: .or(name: "a", filterType: .facet))

    XCTAssertFalse(filterState.getFilters(forGroupWithID: .or(name: "a", filterType: .facet)).isEmpty)
    XCTAssertTrue(filterState.getFilters(forGroupWithID: .or(name: "a", filterType: .facet)).contains(.facet(Filter.Facet(attribute: "size", floatValue: 40))))
    XCTAssertTrue(filterState.getFilters(forGroupWithID: .or(name: "a", filterType: .facet)).contains(.facet(Filter.Facet(attribute: "count", floatValue: 25))))

  }

  func testDisjunctiveFacetAttributes() {

    var filterState = GroupsStorage()

    filterState.addAll(filters: [
      Filter.Facet(attribute: "color", stringValue: "red"),
      Filter.Facet(attribute: "color", stringValue: "green"),
      Filter.Facet(attribute: "color", stringValue: "blue")
    ], toGroupWithID: .or(name: "g1", filterType: .facet))

    XCTAssertEqual(filterState.getDisjunctiveFacetsAttributes(), ["color"])

    filterState.add(Filter.Facet(attribute: "country", stringValue: "france"), toGroupWithID: .or(name: "g2", filterType: .facet))

    XCTAssertEqual(filterState.getDisjunctiveFacetsAttributes(), ["color", "country"])

    filterState.add(Filter.Facet(attribute: "country", stringValue: "uk"), toGroupWithID: .or(name: "g2", filterType: .facet))

    filterState.add(Filter.Facet(attribute: "size", floatValue: 40), toGroupWithID: .or(name: "g2", filterType: .facet))

    XCTAssertEqual(filterState.getDisjunctiveFacetsAttributes(), ["color", "country", "size"])

    filterState.add(Filter.Numeric(attribute: "price", operator: .greaterThan, value: 50), toGroupWithID: .and(name: "g3"))
    filterState.add(Filter.Facet(attribute: "featured", boolValue: true), toGroupWithID: .and(name: "g3"))

    XCTAssertEqual(filterState.getDisjunctiveFacetsAttributes(), ["color", "country", "size"])

    filterState.add(Filter.Numeric(attribute: "price", operator: .lessThan, value: 100), toGroupWithID: .and(name: "g3"))

    XCTAssertEqual(filterState.getDisjunctiveFacetsAttributes(), ["color", "country", "size"])

    filterState.add(Filter.Facet(attribute: "size", floatValue: 42), toGroupWithID: .or(name: "g2", filterType: .facet))

    XCTAssertEqual(filterState.getDisjunctiveFacetsAttributes(), ["color", "country", "size"])

    filterState.removeAll([
      Filter.Facet(attribute: "color", stringValue: "red"),
      Filter.Facet(attribute: "color", stringValue: "green"),
      Filter.Facet(attribute: "color", stringValue: "blue")
    ], fromGroupWithID: .or(name: "g1", filterType: .facet))

    XCTAssertEqual(filterState.getDisjunctiveFacetsAttributes(), ["country", "size"])

  }

  func testRefinements() {

    var filterState = GroupsStorage()

    filterState.addAll(filters: [
      Filter.Facet(attribute: "color", stringValue: "red"),
      Filter.Facet(attribute: "color", stringValue: "green"),
      Filter.Facet(attribute: "color", stringValue: "blue")
    ], toGroupWithID: .or(name: "g1", filterType: .facet))

    XCTAssertEqual(filterState.getRawFacetFilters()["color"].flatMap(Set.init), Set(["red", "green", "blue"]))

    filterState.add(Filter.Facet(attribute: "country", stringValue: "france"), toGroupWithID: .or(name: "g2", filterType: .facet))

    XCTAssertEqual(filterState.getRawFacetFilters()["color"].flatMap(Set.init), Set(["red", "green", "blue"]))
    XCTAssertEqual(filterState.getRawFacetFilters()["country"], ["france"])

    filterState.add(Filter.Facet(attribute: "country", stringValue: "uk"), toGroupWithID: .and(name: "g3"))

    XCTAssertEqual(filterState.getRawFacetFilters()["color"].flatMap(Set.init), Set(["red", "green", "blue"]))
    XCTAssertEqual(filterState.getRawFacetFilters()["country"].flatMap(Set.init), Set(["france", "uk"]))

    filterState.remove(Filter.Facet(attribute: "color", stringValue: "green"), fromGroupWithID: .or(name: "g1", filterType: .facet))

    XCTAssertEqual(filterState.getRawFacetFilters()["color"].flatMap(Set.init), Set(["red", "blue"]))
    XCTAssertEqual(filterState.getRawFacetFilters()["country"].flatMap(Set.init), Set(["france", "uk"]))

  }

  func testFilterScoring() {

    var filterState = GroupsStorage()

    let filterFacet1 = Filter.Facet(attribute: Attribute("category"), value: "table", score: 5)
    let filterFacet2 = Filter.Facet(attribute: Attribute("category"), value: "chair", score: 10)
    let filterFacet3 = Filter.Facet(attribute: Attribute("type"), value: "equipment", score: 3)
    
    
    let groupFacetsOr = FilterGroup.ID.or(name: "filterFacetsOr", filterType: .facet)
    let groupFacetsAnd = FilterGroup.ID.and(name: "filterFacetsAnd")
    
    filterState.add(filterFacet1, toGroupWithID: groupFacetsOr)
    filterState.add(filterFacet2, toGroupWithID: groupFacetsOr)
    filterState.add(filterFacet3, toGroupWithID: groupFacetsAnd)
    
    let expectedResult = """
                                    ( "type":"equipment<score=3>" ) AND ( "category":"chair<score=10>" OR "category":"table<score=5>" )
                                    """

    XCTAssertEqual(filterState.buildSQL(), expectedResult)
    
    let expectedResultLegacy: [[String]]? = [["type:equipment<score=3>"],["category:chair<score=10>", "category:table<score=5>"]]
    XCTAssertEqual(FilterGroupConverter().legacy(filterState.toFilterGroups()), expectedResultLegacy)
    
  }

}
