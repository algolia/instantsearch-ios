![InstantSearch iOS](./docgen/assets/img/InstantSearch-iOS-ReadMe.png)

<p align="left">
<img src="https://img.shields.io/badge/platform-iOS-blue.svg?style=flat" alt="Platform iOS" />
<a href="https://developer.apple.com/swift"><img src="https://img.shields.io/badge/Swift-4.0-blue.svg" alt="Swift 4 compatible" /></a>
<a href="https://developer.apple.com/documentation/objectivec"><img src="https://img.shields.io/badge/Objective--C-compatible-blue.svg" alt="Objective-C compatible" /></a>
<a href="https://cocoapods.org/pods/XLActionController"><img src="https://img.shields.io/cocoapods/v/InstantSearch.svg" alt="CocoaPods compatible" /></a>
<a href="https://raw.githubusercontent.com/algolia/InstantSearch/master/LICENSE"><img src="http://img.shields.io/badge/license-MIT-blue.svg?style=flat" alt="License: MIT" /></a>
</p>

By [Algolia](http://algolia.com).

InstantSearch family: **InstantSearch iOS** | [InstantSearch Android][instantsearch-android-github] | [React InstantSearch][react-instantsearch-github] | [InstantSearch.js][instantsearch-js-github].

**InstantSearch iOS** is a framework providing widgets and helpers to help you build the best instant-search experience on iOS with Algolia. It is built on top of Algolia's [Swift API Client](https://github.com/algolia/algoliasearch-client-swift) library to provide you a high-level solution to quickly build various search interfaces.

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
pod 'InstantSearch', '~> 2.0'
# pod 'InstantSearch/Widgets' for access to everything
# pod 'InstantSearch/Core' for access to everything except the UI widgets
# pod 'InstantSearch/Client' for access only to the API Client
```

Then, run the following command:

```bash
$ pod update
```

#### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a simple, decentralized dependency manager for Cocoa.

To install InstantSearch, simply add the following line to your Cartfile:

```ruby
github "algolia/instantsearch-ios" ~> 2.0 # for access to everything
# github "algolia/instantsearch-core-swift" ~> 3.0 # for access to everything except the UI widgets
# github "algolia/algoliasearch-client-swift" ~> 5.0 # for access only to the API Client
```

#### SwiftPM 

The API client is the only library of the framework available on SwiftPM.

To install the API Client, add `.package(url:"https://github.com/algolia/algoliasearch-client-swift", from: "5.0.0")` to your package dependencies array in Package.swift, then add `AlgoliaSearch` to your target dependencies.

## Documentation

**You can start with the [Getting Started Guide](https://community.algolia.com/instantsearch-ios/getting-started.html).**

Learn more about instantSearch iOS in the [dedicated documentation website](https://community.algolia.com/instantsearch-ios).

## Basic Usage

In your `AppDelegate.swift`: 

```swift
import InstantSearch

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    // Configure InstantSearch
    InstantSearch.shared.configure(appID: "latency", apiKey: "1f6fd3a6fb973cb08419fe7d288fa4db", index: "bestbuy_promo")
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
    InstantSearch.shared.registerAllWidgets(in: self.view)
}
```

Run your app and you will the most basic search experience: a `UISearchBar` with the number of results each time you write a query.

To get a more meaningful search experience, please follow our [Getting Started Guide](https://community.algolia.com/instantsearch-ios/getting-started.html).

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

[react-instantsearch-github]: https://github.com/algolia/react-instantsearch/
[instantsearch-android-github]: https://github.com/algolia/instantsearch-android
[instantsearch-js-github]: https://github.com/algolia/instantsearch.js
