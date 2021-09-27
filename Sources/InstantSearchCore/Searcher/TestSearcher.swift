//
//  TestSearcher.swift
//  
//
//  Created by Vladislav Fitc on 22/07/2021.
//

import Foundation

func example() {

  // Independent searchers with a shared query

  let sharedQuery = Query()

  let hitsSearcher1 = HitsSearcher(appID: "APPID1",
                                   apiKey: "APIKEY1",
                                   indexName: "myIndex1",
                                   query: sharedQuery)

  hitsSearcher1.search()

  let hitsSearcher2 = HitsSearcher(appID: "APPID2",
                                   apiKey: "APIKEY2",
                                   indexName: "myIndex2",
                                   query: sharedQuery)

  hitsSearcher2.search()

  let facetsSearcher = FacetSearcher(appID: "APPID3",
                                      apiKey: "APIKEY3",
                                      indexName: "myIndex",
                                      facetName: "brand",
                                      query: sharedQuery)

  facetsSearcher.search()

  // Composite searcher

  let compositeSearcher = CompositeSearcher(appID: "anotherAPPID",
                                            apiKey: "anotherAPIKey")
  compositeSearcher.addHitsSearcher(indexName: "myIndex2", query: sharedQuery)
  compositeSearcher.addHitsSearcher(indexName: "myIndex", query: sharedQuery)
  compositeSearcher.addFacetsSearcher(indexName: "myIndex", query: sharedQuery, attribute: "brand", facetQuery: "")

  let hitsSearcher = HitsSearcher(appID: "", apiKey: "", indexName: "")
  compositeSearcher.addSearcher(hitsSearcher)

  let facetSearcher = FacetSearcher(appID: "", apiKey: "", indexName: "", facetName: "")
  compositeSearcher.addSearcher(facetSearcher)

  compositeSearcher.search()

  let queryInputInteractor2 = QueryInputInteractor()
  queryInputInteractor2.connectSearcher(compositeSearcher)
  queryInputInteractor2.connectSearcher(compositeSearcher)
  queryInputInteractor2.connectSearcher(facetSearcher)

  let filterState = FilterState()
  filterState.connectSearcher(compositeSearcher)
  filterState.connectSearcher(compositeSearcher)
  filterState.connectSearcher(facetSearcher)

  let switchIndexInteractor = SwitchIndexInteractor(indexNames: ["products", "products-price-asc", "products-price-desc"], selectedIndexName: "products")
  switchIndexInteractor.connectSearcher(compositeSearcher)
  switchIndexInteractor.connectSearcher(compositeSearcher)
  switchIndexInteractor.connectSearcher(facetSearcher)

}

struct QueryInputInteractorTextualQuerySearcher {

}
