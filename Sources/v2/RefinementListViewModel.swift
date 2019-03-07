////
////  RefinementListViewModel.swift
////  InstantSearch
////
////  Created by Guy Daher on 04/03/2019.
////
//
//import Foundation
//
//public class RefinementListViewModel {
//
//  // MARK: - Properties
//
//  // TODO: Rename all constants and internal classes to be consistent with names here.
//  public struct Settings {
//    public var areRefinedValuesShownFirst = Constants.Defaults.refinedFirst
//    public var `operator` = Constants.Defaults.refinementOperator
//    public var areMultipleSelectionsAllowed = Constants.Defaults.areMultipleSelectionsAllowed
//    public var maximumNumberOfRows = Constants.Defaults.limit
//    public var sorting: TransformRefinementList = .countDesc
//
//    public enum RefinementOperator {
//      case and
//      case or
//    }
//  }
//
//  public var settings: Settings
//
//  public var attribute: String
//
//  public var facetResults: [FacetValue]?
//
//  public init(attribute: String, query: Query, settings: Settings? = nil) {
//    self.attribute = attribute
//    self.settings = settings ?? Settings()
//
//    if query.facets == nil {
//      query.facets = [attribute]
//    } else if let facets = query.facets, !facets.contains(attribute) {
//      query.facets! += [attribute]
//    }
//  }
//
//  public func update(with searchResults: SearchResults) {
//    // Use the new SearcherResults
//    if let results = searcher.results, let facetCounts = results.facets(name: attribute) {
//      facetResults = getRefinementList(params: searcher.params,
//                                       facetCounts: facetCounts,
//                                       andFacetName: attribute,
//                                       transformRefinementList: settings.sorting,
//                                       areRefinedValuesFirst: settings.refinedFirst)
//
//    }
//  }
//
//  public func numberOfRows() -> Int {
//    return min(facetResults.count, limit)
//  }
//
//  public func facetForRow(at indexPath: IndexPath) -> FacetValue {
//    return facetResults[indexPath.row]
//  }
//
//  public func isRefined(at indexPath: IndexPath) -> Bool {
//    return searcher.params.hasFacetRefinement(name: attribute, value: facetResults[indexPath.item].value)
//  }
//
//  /// This simulated selecting a facet
//  /// it will tggle the facet refinement, deselect the row and then execute a search
//  public func didSelectRow(at indexPath: IndexPath) {
//
//    if isDisjunctive {
//      searcher.params.setFacet(withName: attribute, disjunctive: true)
//      searcher.params.toggleFacetRefinement(name: attribute, value: facetResults[indexPath.item].value)
//    } else if !isDisjunctive && areMultipleSelectionsAllowed {
//      searcher.params.setFacet(withName: attribute, disjunctive: false)
//      searcher.params.toggleFacetRefinement(name: attribute, value: facetResults[indexPath.item].value)
//    } else {
//      // when conjunctive and one single value can be selected,
//      // we need to keep the other values visible, so we still do a disjunctive facet
//      searcher.params.setFacet(withName: attribute, disjunctive: true)
//      let value = facetResults[indexPath.item].value
//
//      if searcher.params.hasFacetRefinement(name: attribute, value: value) { // deselect if already selected
//        searcher.params.clearFacetRefinements(name: attribute)
//      } else { // select new one only.
//        searcher.params.clearFacetRefinements(name: attribute)
//        searcher.params.addFacetRefinement(name: attribute, value: value)
//      }
//
//    }
//    view?.deselectRow(at: indexPath)
//    searcher.search()
//  }
//}
//
//extension RefinementListViewModel: ResultingDelegate {
//  public func on(results: SearchResults?, error: Error?, userInfo: [String: Any]) {
//
//    defer {
//      view?.reloadRefinements()
//    }
//
//    guard let results = results else {
//      print(error ?? "")
//      return
//    }
//
//    guard let facetCounts = results.facets(name: attribute) else {
//      print("No facet counts found for attribute: \(attribute)")
//      facetResults = []
//
//      return
//    }
//
//    facetResults = getRefinementList(params: searcher.params,
//                                     facetCounts: facetCounts,
//                                     andFacetName: attribute,
//                                     transformRefinementList: transformRefinementList,
//                                     areRefinedValuesFirst: refinedFirst)
//  }
//}
//
//extension RefinementListViewModel: ResettableDelegate {
//  func onReset() {
//    view?.reloadRefinements()
//  }
//}
//
//
//extension RefinementListViewModel {
//  @objc internal func getRefinementList(params: SearchParameters,
//                                        facetCounts: [String: Int],
//                                        andFacetName facetName: String,
//                                        transformRefinementList: TransformRefinementList,
//                                        areRefinedValuesFirst: Bool) -> [FacetValue] {
//
//    let allRefinements = params.buildFacetRefinements()
//    let refinementsForFacetName = allRefinements[facetName]
//
//    let facetList = FacetValue.listFrom(facetCounts: facetCounts, refinements: refinementsForFacetName)
//
//    let sortedFacetList = facetList.sorted { (lhs, rhs) in
//
//      let lhsChecked = params.hasFacetRefinement(name: facetName, value: lhs.value)
//      let rhsChecked = params.hasFacetRefinement(name: facetName, value: rhs.value)
//
//      if areRefinedValuesFirst && lhsChecked != rhsChecked { // Refined wins
//        return lhsChecked
//      }
//
//      let leftCount = lhs.count
//      let rightCount = rhs.count
//      let leftValueLowercased = lhs.value.lowercased()
//      let rightValueLowercased = rhs.value.lowercased()
//
//      switch transformRefinementList {
//      case .countDesc:
//        if leftCount != rightCount { // Biggest Count wins
//          return leftCount > rightCount
//        } else {
//          return leftValueLowercased < rightValueLowercased // Name ascending wins by default
//        }
//
//      case .countAsc:
//        if leftCount != rightCount { // Smallest Count wins
//          return leftCount < rightCount
//        } else {
//          return leftValueLowercased < rightValueLowercased // Name ascending wins by default
//        }
//
//      case .nameAsc:
//        if leftValueLowercased != rightValueLowercased {
//          return leftValueLowercased < rightValueLowercased // Name ascending
//        } else {
//          return leftCount > rightCount // Biggest Count wins by default
//        }
//
//      case .nameDsc:
//        if leftValueLowercased != rightValueLowercased {
//          return leftValueLowercased > rightValueLowercased // Name descending
//        } else {
//          return leftCount > rightCount // Biggest Count wins by default
//        }
//      }
//    }
//
//    return sortedFacetList
//  }
//}
