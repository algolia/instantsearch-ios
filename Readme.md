# InstantSearch

<p align="left">
<img src="https://img.shields.io/badge/platform-iOS-blue.svg?style=flat" alt="Platform iOS" />
<a href="https://developer.apple.com/swift"><img src="https://img.shields.io/badge/swift3-compatible-4BC51D.svg?style=flat" alt="Swift 3 compatible" /></a>
<a href="https://cocoapods.org/pods/XLActionController"><img src="https://img.shields.io/cocoapods/v/InstantSearch-iOS.svg" alt="CocoaPods compatible" /></a>
<a href="https://raw.githubusercontent.com/algolia/InstantSearch/master/LICENSE"><img src="http://img.shields.io/badge/license-MIT-blue.svg?style=flat" alt="License: MIT" /></a>
</p>

By [Algolia](http://algolia.com).


## Warning

**This repo is still in beta**. Do not use it in production as the APIs can still change.

-----

**InstantSearch iOS** is a library providing widgets and helpers to help you build the best instant-search experience on iOS with Algolia. It is built on top of Algolia's [Swift API Client](https://github.com/algolia/algoliasearch-client-swift) to provide you a high-level solution to quickly build various search interfaces.

<!-- <img src="Example/InstantSearch.gif" width="300"/> -->

## Demo

You can see InstantSearch iOS in action in our [Examples repository][ecommerce-url], in which we published example apps built with InstantSearch and written in Swift:

<p align="center">
  <img src="./docgen/assets/img/ikea.gif"/>
</p>

[ecommerce-gif]: ./docgen/assets/img/ikea.gif
[ecommerce-url]: https://github.com/algolia/instantsearch-swift-examples

## Installation

#### CocoaPods

[CocoaPods](https://cocoapods.org/) is a dependency manager for Cocoa projects.

To install InstantSearch, simply add the following line to your Podfile:

```ruby
pod 'InstantSearch-iOS', '~> 1.0.0-beta4'
```

## Usage

In your `AppDelegate.swift`: 

```swift
import InstantSearch

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    // Configure InstantSearch
    InstantSearch.reference.configure(appID: "latency", apiKey: "1f6fd3a6fb973cb08419fe7d288fa4db", index: "bestbuy_promo")
}
```

In your `ViewController.swift`:

```swift
import InstantSearch

override func viewDidLoad() {
    super.viewDidLoad()

    let searchBar = SearchBarWidget(frame: CGRect(x: 20, y: 30, width: 300, height: 40))
    let statsWidget = StatsLabelWidget(frame: CGRect(x: 20, y: 80, width: 300, height: 50))
    self.view.addSubview(searchBar)
    self.view.addSubview(statsWidget)

    // Add all widgets in view to InstantSearch
    InstantSearch.reference.addAllWidgets(in: self.view)
}
```

Run your app and you will the most basic search experience: a `UISearchBar` with the number of results each time you write a query.

## Getting Help

- **Need help**? Ask a question to the [Algolia Community](https://discourse.algolia.com/) or on [Stack Overflow](http://stackoverflow.com/questions/tagged/algolia).
- **Found a bug?** You can open a [GitHub issue](https://github.com/algolia/algoliasearch-client-swift/issues).
- **Questions about Algolia?** You can search our [FAQ in our website](https://www.algolia.com/doc/faq/).


## Getting involved

* If you **want to contribute** please feel free to **submit pull requests**.
* If you **have a feature request** please **open an issue**.
* If you use **InstantSearch** in your app, we would love to hear about it! Drop us a line on [discourse](https://discourse.algolia.com/) or [twitter](https://twitter.com/algolia).

# License

InstantSearch iOS is [MIT licensed](LICENSE.md).