# InstantSearch iOS

**InstantSearch iOS** is a declarative UI library providing widgets and helpers for building native, component-driven UIs with Algolia.
It is built on top of Algolia's [iOS API Client](https://github.com/algolia/algoliasearch-client-swift) and [iOS InstantSearch Core Client](https://github.com/algolia/instantsearch-core-swift) to provide you a high-level solution to quickly build various search interfaces.

## Widgets

The core part of InstantSearch iOS are the widgets, which are search-aware components that are binded to search events coming from Algolia.

Widgets binds `UIKit UIViews`, whether it is an advanced `UICollectionView`, or a simple `UISlider`.
They are also customisable by exposing `IBInspectable` parameters that can be set right through Interface Builder.

The nice thing about InstantSearch iOS is that you don't have to rewrite your existing `UIViews` to start using the library.
In fact, the architecture of the library is mostly protocol oriented, making it extendible and compatible with your existing UI.
It follows Plugin Architecture conventions by providing most of the business logic mostly through protocols, and sometimes through base `UIViewController` classes.

In that way, it is also very easy to create your own search-aware custom widgets. All it takes is implementing one or more protocols depending on the purpose of the widget, and then writing the business logic using the provided properties and methods coming from the protocols.

## Implementation Notes

### Architecture of InstantSearch

 InstantSearch is inspired by both MVVM architecture.

 This is an overview of the architecture:

 ```
 View <--> ViewModel <--> Binder <--> Interactor/Model
 ```

 Widgets can mean two things, depending on how modular you want your components to be:


 1. It can be the View

 ```
 WidgetV <--> WidgetVM <--> Binder <--> Searcher
 ```

 In this first case, we offer a better modular architecture where a WidgetVM can be reused
 for different kind of widgets, for example: a collectionView and tableView can share
 the same VM since the business logic is exactly the same, only the layout changes.
 In that case, the Widget is independent of InstantSearchCore and WidgetVM is independent of UIKit.


 2. It can be the View and the ViewModel

 ```
 WidgetVVM <--> Binder <--> Searcher
 ```

 In this second case, we offer an easier way to create new widgets since the widget has access
 to the searcher and all of its method. The downside here is that we can't reuse the business logic
 through a VM. The upside is that it's easy for 3rd party devs to create their own widgets and plug into IS.
 In that case, the Widget is dependent on both InstantSearchCore and UIKit.
 We note that the View and the ViewModel depend on abstract delegates, which makes them reusable and testable.

 Finally, the Binder plays a role of exposing all possible search events, whether from the Searcher or other widgets,
 and making them available for ViewModels or Views so that they can tune in.
 In a way, it is like an observable that knows about all search events, and it will send the search events to
 the observers that decided to tune in. We decided to go with delegation to offer a clean safe interface.

### InstantSearch Notes

 InstantSearch does mainly 3 things:
 
 1. Scans the View to find Algolia Widgets
 2. Knows about all search events, whether coming from the Searcher or other widgets
 3. Binds Searcher - Widgets through delegation

For the 3rd point, InstantSearch binds the following:
 
 - Searcher and WidgetV through a ViewModelFetcher that creates the appropriate WidgetVM
 - Searcher and WidgetVVM