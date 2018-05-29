---
title: Use a Custom Backend
layout: main.pug
name: custom-backend
category: main
withHeadings: true
navWeight: 100
editable: true
githubSource: docgen/src/custom-backend.md
---


## Who should use this guide

Advanced InstantSearch users may have the need to query Algolia’s servers from their backend instead of the frontend, while still being able to reuse InstantSearch widgets. Possible motivations could be for security restrictions, for SEO purposes or to enrich the data sent by the custom server (i.e. fetch Algolia data and data from their own servers). If this sounds appealing to you, feel free to follow this guide. Keep in mind though that we, at Algolia, recommend doing frontend search for performance and high availability reasons.

By the end of this guide, you will have learned how to leverage InstantSearch with your own backend architecture to query Algolia. Even if you're not using Algolia on your backend and still want to benefit from using InstantSearch, then this guide is also for you.

## A quick overview on how InstantSearch works

InstantSearch, as you probably know, offers reactive UI widgets that automatically update when new search events occur. Internally, it uses a `Searchable` interface that takes care of making network calls to get search results. The most important method of that `Searchable` is a simple `search()` function that takes in a parameter that contains all the search query parameters, and then expects a callback to be called with the search results that you get from your backend. Let's see how this works in action

## A basic implementation of using a custom backend

The most basic implementation of using a custom backend uses the `DefaultSearchClient` and requires you to implement just one method: `search(query:searchResultsHandler:)`. In this function, you use the query passed to you, make a network request to your backend server, transform the response into a `SearchResults` instance, and then finally call the `searchResultsHandler` callback with the searchResults. In case of error, you call the callback with the error. Here is an example using the Alamofire networking library.

``` swift
public class DefaultCustomBackend: DefaultSearchClient {
    override public func search(_ query: Query, searchResultsHandler: @escaping SearchResultsHandler) {
        // 1
        let queryText = query.query ?? ""
        
        // 2
        Alamofire.request("https://yourbackend.com/search?q=\(queryText)").responseJSON { responseJson in
            
            if let json = responseJson.result.value as? [String: Any] {
                do {
                    // 3
                    let searchResults = try SearchResults(content: json, disjunctiveFacets: [])
                    
                    // 4
                    searchResultsHandler(searchResults, nil)
                } catch let error {
                    // 4
                    searchResultsHandler(nil, error)
                }
            }
        }
    }
}
```

This is the simplest example and will work only if on your backend, you're calling Algolia and then just forwarding your result to the mobile app without doing any modification to the json data.

1- Get the query text from the Query parameter that is passed in the method.

2- Make your request to your backend using the queryText parse in step 1.

3- Serialise your response into a `SearchResults` instance. In case your response data is different than the original one returned by Algolia, especially in the case where you're not using Algolia at all in your backend, then you can use one of our initialiser of SearchResults such as `SearchResults(nbHits:hits)`.

4- Call the `searchResultsHandler` function in order to instruct InstantSearch about the new search event, in this case the arrival of new search results, or an error. 

## A more advanced implementation of using a custom backend

The above snippet only covers the case of doing a basic search of hits, with conjunctive (contrary to disjunctive) filtering. Here, we'll take a look at improving the structure of our custom backend class, as well as supporting disjunctive faceting. 

let's start with the code snippet

```swift

// 1
public struct BackendSearchParameters {
    var q: String?
    var disjunctiveFacets: [String]?
}
public struct BackendSearchResults {
    var total: Int
    var hits: [[String: Any]]
}

// 2
public class BackendImplementation: SearchClient<BackendSearchParameters, BackendSearchResults> {

    // 3
    public override func map(query: Query) -> BackendSearchParameters {
        let queryText = query.query
        
        return BackendSearchParameters(q: queryText, disjunctiveFacets: nil)
    }
    
    // 4
    public override func map(query: Query, disjunctiveFacets: [String], refinements: [String : [String]]) -> BackendSearchParameters {
        let queryText = query.query
        
        return BackendSearchParameters(q: queryText, disjunctiveFacets: disjunctiveFacets)
    }
    
    // 5
    public override func map(results: BackendSearchResults) -> SearchResults {
        let nbHits = results.total
        let hits = results.hits
        
        // 6
        let categoryFacet = ["chairs": 10, "tables": 15]
        let facets = ["category": categoryFacet]
        let extraContent = ["facets": facets]
        
        return SearchResults(nbHits: nbHits, hits: hits, extraContent: extraContent)
    }
    
    // 7
    public override func search(_ query: BackendSearchParameters, searchResultsHandler: @escaping SearchResultsHandler) {
        
        let queryText = query.q ?? ""
        
        Alamofire.request("https://yourbackend.com/search?q=\(queryText)").responseJSON { responseJson in
            
            if let json = responseJson.result.value as? [String: Any] {
                do {
                    
                    let hitsJson = json["hits"] as! [String: Any]
                    let total = hitsJson["total"] as! Int
                    let hits = hitsJson["hits"] as! [[String: Any]]
                    
                    let backendSearchResults = BackendSearchResults(total: total, hits: hits)
                    
                    // 8
                    searchResultsHandler(backendSearchResults, nil)
                    
                } catch let error {
                    searchResultsHandler(nil, error)
                }
            }
        }
        
    }
}
```

1- Create your models that will hold the query parameters and results that you need in order to make your custom backend call

2- Create your class that inherits from `SearchClient`. Use your 2 models created in 1 for the generics of that class. This is will ensure strong typing and good practices throughout this implementation.

3- Implement the basic param mapper function that converts a query to your parameter model. Make sure to take all the fields you need from the query parameter.

4- Implement the advanced param mapper function. It is the same as 3, but with 2 more parameters that you can use for your call: `disjunctiveFacets` and `refinements`.

5- Implement the result mapper function that converts your result model back to an Algolia `SearchResults` that can be understood by InstantSearch. 

6- In case you want to specify the possible facets for a refinement list, make sure to specify the facets property appropriately. In the code snippet, we just give an example, but usually you'll want to get this data from your custom result model.

7- Implement the search method, same idea as the basic implementation. The only difference is that now it provides your custom parameter model as its parameter.

8- When you get new search results, you serialise them into your custom response model and then call the `searchResultsHandler` method.


## Last trick to get more out of the query
One little trick you can use to get more detailed information about the `query` being passed as a parameter is to upcast it to a `SearchParameters` by doing 

```
let searchParameters = query as! SearchParameters
```

In that way, you can access to higher level properties like `disjunctiveFacets`, `facetRefinements`, `disjunctiveNumerics` and `numericRefinements`. This can be useful when transforming Algolia's Query.

