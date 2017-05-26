---
title: Main Concepts
layout: main.pug
name: concepts
category: main
withHeadings: true
navWeight: 10
---

**InstantSearch iOS** is a declarative UI library providing widgets and helpers for building native, component-driven UIs with Algolia.
It is built on top of Algolia's [iOS API Client](https://github.com/algolia/algoliasearch-client-swift) and [iOS InstantSearch Core Client](https://github.com/algolia/instantsearch-core-swift) to provide you a high-level solution to quickly build various search interfaces.


In this guide, you will learn the key concepts of InstantSearch iOS.


## InstantSearch Core

The InstantSearch library is built on top of InstantSearch Core. At the core of InstantSearch core is the **Searcher**, which will wrap an [Algolia API `Client`](hhttps://github.com/algolia/algoliasearch-client-swift/blob/master/Source/Client.swift) and provide a level of abstraction over it. You can think of InstantSearch Core as the UIKit independent library that takes care of everything related to the search session, while InstantSearch is a UIKit dependent library uses InstantSearch Core to offer ready-made configurable widgets that are "search aware" and automatically react to all kinds of search events. For more info about InstantSearchCore, checkout its [community website](https://community.algolia.com/instantsearch-core-swift/).

## Widgets

The core part of InstantSearch iOS are the widgets, which are search-aware UI components that are binded to search events coming from Algolia. We provide some universal widgets such as the **`SearchBarWidget`**, the **`HitsWidget`** or the **`RefinementListWidget`**, and you can easily create new ones by implementing the a few protocols (discussed below).

Widgets inherit from the different UIKit `UIViews`, whether it is an advanced `UICollectionView`, or a simple `UISlider`. They are also customizable by exposing `IBInspectable` parameters that can be set right through Interface Builder.

The nice thing about InstantSearch iOS is that you don't have to rewrite your existing `UIViews` to start using the library. In fact, the architecture of the library is mostly protocol-oriented, making it extendible and compatible with your existing UI. It follows Plugin Architecture conventions by providing most of the business logic mostly through protocols, and sometimes through base UIViewController classes.

In that way, it is also very easy to create your own search-aware custom widgets. All it takes is implementing one or more protocols depending on the purpose of the widget, and then writing the business logic using the provided properties and methods coming from the protocols.

## Protocols

Let's talk about the 4 most important protocols used throughout InstantSearch iOS. This will help you understand how things work under the hood, and help you write your own custom widgets later on. But first, let's see the 2 types of widgets that we have.

A widget can either be an **input widget** with which the user can interact with (e.g: searchBar), an **output widget** with which the user can see results (e.g: hits), or both (e.g: refinementList). In both cases, all widgets implement the `AlgoliaWidget` protocol, which is an empty marker protocol used to identify all Algolia related widgets in the `UIView's ViewController`.

An input widget will implement `SearchableViewModel`. By implementing this protocol, the widget will have a reference to `Searcher`, and will therefore be able to use it to trigger methods such as `#search()` (e.g: `UISearchBar`), or `#params.updateNumericRefinement` (e.g: `UISlider`).

An output widget is basically a delegate that reacts to new "search events" that are triggered by the user interacting with an input widget, whether it is writing in a search bar or selecting a new filter. An output widget can implement one of the 2 following protocols: `ResultingDelegate` where the widget can process the results or handle the error of a search request to Algolia, and `RefinableDelegate` where the widget receives events when search parameters are being altered in the `Searcher`.



TODO: do a diagram!

A new search event is triggered by triggering the `Searcher#search()` method. When a new search event is triggered by one widget

The Searcher is responsible of all search requests: when `Searcher#search()` is called, the Searcher will fire a request with the current query, and will forward the search results to its **delegates**.

```swift
                                    ┌-> A implements ResultingDelegate
Searcher.search(query) -> algolia --┤
                                    └-> B implements ResultingDelegate
```

A listener is an object implementing the [`AlgoliaResultsListener`](instantsearch/src/main/java/com/algolia/instantsearch/model/AlgoliaResultsListener.java) interface: this object's `onResults` or `onError` method will be called after each search request returns to let you either process the results or handle the error. You can add a listener to a Searcher by calling `Searcher#registerListener()`.


```java
                ┌→ (error) onError(final Query query, final AlgoliaException error);
new Search -> -─┤
                └→ (success) onResults(SearchResults results, boolean isLoadingMore);
```

## InstantSearchHelper

The Searcher is UI-agnostic, and only communicates with its listeners. On top of it, we provide you a component which will link it to your user interface: the **InstantSearchHelper**.

The InstantSearchHelper will use the Searcher to react to changes in your application's interface, like when your user types a new query or interacts with Widgets.

Linked to a `SearchView`, it will watch its content to send any new query to the `Searcher`. When the query's results arrive, the `InstantSearchHelper` will forward them to its `AlgoliaWidgets`.


```java
        SearchView.onQueryTextListener.onQueryTextChange()
                               │
                               ↓
             searcher.search(searchView.getQuery())
                               │
            ┌──────────────────┴──────────────────┐
            ↓                                     ↓
Widget1.onResults(hits, isLoadingMore) Widget2.onResults(hits, isLoadingMore)
```

## Widgets

Widgets are the UI building blocks of InstantSearch iOS, linked together by an `InstantSearchHelper` to help you build instant-search interfaces. We provide some universal widgets such as the **`SearchBox`**, the **`Hits`** or the **`RefinementList`**, and you can easily create new ones by implementing the [`AlgoliaWidget`](instantsearch/src/main/java/com/algolia/instantsearch/ui/views/AlgoliaWidget.java) interface.

### Anatomy of an `AlgoliaWidget`

An **`AlgoliaWidget`** is a specialization of the `AlgoliaResultsListener` interface used by the `Searcher` to notify its listeners of search results.  
Beyond reacting to search results with `onResults` and to errors in `onError`, an `AlgoliaWidget` exposes an `onReset` method which will be called when the interface is reset (which you can trigger via `InstantSearchHelper#reset()`).
When linked to a `Searcher`, the widget's `setSearcher` method will be called to provide it a reference to its Searcher, which is useful to some widgets. For example, the `Hits` widget uses it to load more results as the user scrolls.

## Events

InstantSearch comes with an event system that lets you react during the lifecycle of a search query:
- when a query is fired via a `SearchEvent(Query query, int requestSeqNumber)`
- when its results arrive via a `ResultEvent(JSONObject content, Query query, int requestSeqNumber)`
- when a query is cancelled via a `CancelEvent(Request request, Integer requestSeqNumber)`
- when a request errors via a `ErrorEvent(AlgoliaException error, Query query, int requestSeqNumber)`

We use EventBus to dispatch events. You can register an object to the event bus using `EventBus.getDefault().register(this);` after which it will receive events on methods annotated by `@Subscribe`:

```java
public class Logger {
    Logger() {
        EventBus.getDefault().register(this);
    }

    @Subscribe
    onSearchEvent(SearchEvent e) {
        Log.d("Logger", "Search:" + e.query);
    }

    @Subscribe
    onResultEvent(ResultEvent e) {
        Log.d("Logger", "Result:" + e.query);
    }
}
```

