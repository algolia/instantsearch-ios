# Architecture of InstantSearch

InstantSearch is inspired by the MVVM architecture. 

This is an overview of the architecture:

```
View <--> ViewModel <--> Binder <--> Interactor/Model
                           |
                           V
                         Builder
```

Widgets can mean two things, depending on how modular you want your components to be:


1. It can be the View

```
WidgetV <--> WidgetVM <--> Binder <--> Searcher
                             |
                             V
                           Builder
```

In this first case, we offer a better modular architecture where a WidgetVM can be reused
for different kind of widgets, for example: a collectionView and tableView can share
the same VM since the business logic is exactly the same, only the layout changes.
In that case, the Widget is independent of InstantSearchCore and WidgetVM is independent of UIKit.


2. It can be the View and the ViewModel

```
WidgetVVM <--> Binder <--> Searcher
                 |
                 V
              Builder
```

In this second case, we offer an easier way to create new widgets since the widget has access
to the searcher and all of its method. The downside here is that we can't reuse the business logic
through a VM. The upside is that it's easy for 3rd party devs to create their own widgets and plug into IS.
In that case, the Widget is dependent on both InstantSearchCore and UIKit.

We note that the View and the ViewModel depend on abstract delegates, which makes them reusable and testable.

To explain the remaining 2 components:

1- **Binder**: plays a role of exposing all possible search events, whether from the Searcher or other widgets,
and making them available for ViewModels or Views so that they can tune in.
In a way, it is like an observable that knows about all search events, and it will send the search events to 
the observers that decided to tune in. We decided to go with delegation to offer a clean safe interface.
It also makes sure to call the Builder methods on the Widgets that fit case 1 mentioned above

2- **Builder**: plays the role of spinning up the WidgetVM for the WidgetV, takes care of injecting the concrete implementations into the WidgetV and the WidgetVM, and finally links the delegates of the WidgetV, WidgetVM and the Searcher
