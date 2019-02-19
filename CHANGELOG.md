Change Log
==========
## 2.1.0 (2017-12-12)

- Multi-Index functionality added to all widgets with the introduction of the index and variant field.
- Adding 2 new widgets: `MultiHitsTableWidget` and `MultiHitsCollectionWidget` that can handle multiple indices in different sections.
- Introduction of 6 ViewModels that encapsulate the business logic of the widgets. You can use them to easily access the search state for better customization.
`SearchViewModel`, `HitsViewModel`, `MultiHitsViewModel`, `NumericControlViewModel`, `FacetControlViewModel`, `RefinementMenuViewModel`.

## 2.0.0 (2017-10-01)

### Swift Version

- Add support for Swift 4

## 1.0.1 (2017-07-31)

### Dependency Managers

- Add support for Carthage

## 1.0.0 (2017-07-17)

**First official release of InstantSearch iOS!**

### Features

- 15 customizable widgets to use in your apps. Checkout the documentation of those widgets in the [community website](https://community.algolia.com/instantsearch-ios/widgets.html).
- 4 base controllers: `HitsTableViewController`, `RefinementTableViewController`, `HitsCollectionViewController`, `RefinementCollectionViewController`.
- Custom widget creation. [Follow documentation](https://community.algolia.com/instantsearch-ios/widgets.html#custom-widgets).
- Getting Started Guide. [Follow guide](https://www.algolia.com/doc/guides/building-search-ui/getting-started/ios/).
