# Custom Widgets

This is the best place where the community can contribute to InstantSearch. Since InstantSearch tries to follow a plugin architecture, anyone can easily create a custom search widget and share it to everyone by following 3 steps:

1- Write the presentation logic and layout logic for your `UIView` component. You can do and draw whatever you like here.

2- Implement the `AlgoliaWidget` protocol so that InstantSearch can find and use the widget, along with one or more of the following protocols: `SearchableViewModel`, `ResultingDelegate`, `RefinableDelegate`, `ResettableDelegate`.

3- Write the search logic through search events that are propagated from the delegate methods above. In there, you might need to use the `Searcher` to change the state of the search. For more info, you can check the InstantSearchCore [repo](https://github.com/algolia/instantsearch-core-swift) and [documentation](https://community.algolia.com/instantsearch-core-swift/).

Also, make sure to check out existing custom widget examples to get inspired and understand how it works. 
