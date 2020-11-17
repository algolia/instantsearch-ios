![InstantSearch iOS](./Resources/instantsearch-banner.png)

[![Pod Version](http://img.shields.io/cocoapods/v/InstantSearch.svg?style=flat)](https://github.com/algolia/instantsearch-ios/)
[![Pod Platform](http://img.shields.io/cocoapods/p/InstantSearch.svg?style=flat)](https://github.com/algolia/instantsearch-ios/)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-brightgreen.svg)](https://github.com/algolia/instantsearch-ios/)
[![SwiftPM compatible](https://img.shields.io/badge/SwiftPM-compatible-brightgreen.svg)](https://swift.org/package-manager/)
[![Mac Catalyst compatible](https://img.shields.io/badge/Catalyst-compatible-brightgreen.svg)](https://developer.apple.com/documentation/xcode/creating_a_mac_version_of_your_ipad_app/)
[![Licence](http://img.shields.io/cocoapods/l/InstantSearch.svg?style=flat)](https://opensource.org/licenses/Apache-2.0)

By [Algolia](http://algolia.com).

InstantSearch family: **InstantSearch iOS** | [InstantSearch Android][instantsearch-android-github] | [React InstantSearch][react-instantsearch-github] | [InstantSearch.js][instantsearch-js-github] | [Angular InstantSearch][instantsearch-angular-github] | [Vue InstantSearch][instantsearch-vue-github].

**InstantSearch iOS** is a framework providing components and helpers to help you build the best instant-search experience on iOS with Algolia. It is built on top of Algolia's [Swift API Client](https://github.com/algolia/algoliasearch-client-swift) library to provide you a high-level solution to quickly build various search interfaces.

## Demo

You can see InstantSearch iOS in action in our [Examples repository][examples-url], in which we published search experiences built with InstantSearch and written in Swift:

<p align="center">
<img src="./Resources/instant-results.gif" width="300"/>
</p>

[examples-url]: https://github.com/algolia/instantsearch-swift-examples

## Installation

### Swift Package Manager

The Swift Package Manager is a tool for managing the distribution of Swift code. It’s integrated with the Swift build system to automate the process of downloading, compiling, and linking dependencies. 
Since the release of Swift 5 and Xcode 11, SPM is compatible with the iOS, macOS and tvOS build systems for creating apps. 

To use SwiftPM, you should use Xcode 11 to open your project. Click `File` -> `Swift Packages` -> `Add Package Dependency`, enter [InstantSearch repo's URL](https://github.com/algolia/instantsearch-ios).
If you consider to use only the business logic modules of InstantSearch and don't need the set of provided UIKit controllers in your project, select only 'InstantSearchCore' in the provided list of products.

If you're a framework author and use InstantSearch as a dependency, update your `Package.swift` file:

```swift
let package = Package(
    // 7.6.0 ..< 8.0.0
    dependencies: [
        .package(url: "https://github.com/algolia/instantsearch-ios", from: "7.6.0")
    ],
    // ...
)
```

### CocoaPods

[CocoaPods](https://cocoapods.org/) is a dependency manager for Cocoa projects.

To install InstantSearch, simply add the following line to your Podfile:

```ruby
pod 'InstantSearch', '~> 7.6'
# pod 'InstantSearch/Insights' for access to Insights library only
# pod 'InstantSearch/Core' for access business logic without UIKit components
```

Then, run the following command:

```bash
$ pod update
```

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a simple, decentralized dependency manager for Cocoa.

- To install InstantSearch, simply add the following line to your Cartfile:
```ruby
github "algolia/instantsearch-ios" ~> 7.6
```

- Launch the following commands from the project directory
 ```shell
 carthage update
 ./Carthage/Checkouts/instant-search-ios/carthage-prebuild
 carthage build
 ```

 > NOTE: At this time, Carthage does not provide a way to build only specific repository subcomponents (or equivalent of CocoaPods's subspecs). All components and their dependencies will be built with the above command. However, you don't need to copy frameworks you aren't using into your project. For instance, if you aren't using UI components from `InstantSearch`, feel free to delete that framework from the Carthage Build directory after `carthage update` completes keeping only `InstantSearchCore`.
 
 If this is your first time using Carthage in the project, you'll need to go through some additional steps as explained [over at Carthage](https://github.com/Carthage/Carthage#adding-frameworks-to-an-application).
 

## Documentation

**You can start with the [Getting Started Guide](https://www.algolia.com/doc/guides/building-search-ui/getting-started/ios/).**

Learn more about instantSearch iOS in the [dedicated documentation website](https://www.algolia.com/doc/api-reference/widgets/ios/).

## Basic Usage

In your `ViewController.swift`:

```swift
import InstantSearch

struct BestBuyItem: Codable {
  let name: String
}

struct BestBuyTableViewCellConfigurator: TableViewCellConfigurable {
   
  let model: BestBuyItem
  
  init(model: BestBuyItem, indexPath: IndexPath) {
    self.model = model
  }
  
  func configure(_ cell: UITableViewCell) {
    cell.textLabel?.text = model.name
  }

}

typealias BestBuyHitsViewController = HitsTableViewController<BestBuyTableViewCellConfigurator>

class ViewController: UIViewController {
      
  let searcher = SingleIndexSearcher(appID: "latency",
                                     apiKey: "1f6fd3a6fb973cb08419fe7d288fa4db",
                                     indexName: "bestbuy")
  lazy var searchController: UISearchController = .init(searchResultsController: hitsTableViewController)
  lazy var searchConnector: SingleIndexSearchConnector<BestBuyItem> = .init(searcher: searcher,
                                                                            searchController: searchController,
                                                                            hitsController: hitsTableViewController)
  let hitsTableViewController: BestBuyHitsViewController = .init()
  let statsInteractor: StatsInteractor = .init()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    searchConnector.connect()
    statsInteractor.connectSearcher(searcher)
    statsInteractor.connectController(self)
    searcher.search()
    setupUI()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    searchController.searchBar.becomeFirstResponder()
  }
  
  func setupUI() {
    view.backgroundColor = .white
    navigationItem.searchController = searchController
    searchController.hidesNavigationBarDuringPresentation = false
    searchController.showsSearchResultsController = true
    searchController.automaticallyShowsCancelButton = false
  }
      
}

extension ViewController: StatsTextController {
  
  func setItem(_ item: String?) {
    title = item
  }

}
```

Run your app and you will the most basic search experience: a `UISearchBar` with the number of results each time you write a query.

To get a more meaningful search experience, please follow our [Getting Started Guide](https://www.algolia.com/doc/guides/building-search-ui/getting-started/ios/).

If you only require business logic modules in your project and use `InstantSearchCore` framework, add `import InstantSearchCore` to your source files. 

## Insights

**InstantSearch Insights iOS** library allows developers to capture search-related events. The events maybe related to search queries (such as click an conversion events used for Click Analytics or A/B testing). It does so by correlating events with queryIDs generated by the search API when a query parameter clickAnalytics=true is set. As well library allows to capture search-independent events which can be used for the purpose of search experience personalization. There are three types of these events which are currently supported: click, conversion and view.

### Quick Start

#### Initialize the Insights client

You first need to initialize the Insights client. For that you need your **Application ID** and **API Key**.
You can find them on [your Algolia account](https://www.algolia.com/api-keys).
Also, for the purpose of personalization an application **User Token** can be specified via the corresponding optional parameter. In case of non-specified user token an automatically-generated application-wide user token will be used.

```swift
Insights.register(appId: "testApp", apiKey: "testKey", userToken: "testToken")
```

#### Sending metrics

Once that you registered your **Application ID** and the **API Key** you can easily start sending metrics. 

```swift
Insights.shared?.clickedAfterSearch(eventName: "click event",
                                    indexName: "index name",
                                    objectID: "object id",
                                    position: 1,
                                    queryID: "query id")

Insights.shared?.convertedAfterSearch(eventName: "conversion event",
                                      indexName: "index name",
                                      objectIDs: ["obj1", "obj2"],
                                      queryID: "query id")

Insights.shared?.viewed(eventName: "view event",
                        indexName: "index name",
                        filters: ["brand:apple"])

```


#### Logging and debuging

In case you want to check if the metric was sent correctly, you need to enable the logging first

```swift
Insights.shared(appId: "appId")?.isLoggingEnabled = true
```

After you enabled it, you can check the output for success or error messages


#### Events flush delay

By default the client transmits tracked events every 30 seconds. You can customize this delay by changing `flushDelay` value (in seconds) as follows:

```swift
Insights.flushDelay = 60
```

#### Setting API region

By default each analytics API call is geo-routed so that each call targets the closest API. 
Today the analytics API suports two regions: United States and Germany. You can specify the region your prefer to use as follows: 

```swift
Insights.region = .de
```

## Getting Help

- **Need help**? Ask a question to the [Algolia Community](https://discourse.algolia.com/) or on [Stack Overflow](http://stackoverflow.com/questions/tagged/algolia).
- **Encountering an issue?** Before reaching out to support, we recommend heading to our [FAQ](https://www.algolia.com/doc/guides/building-search-ui/troubleshooting/faq/ios/) where you will find answers for the most common issues and gotchas with the framework.
- **Found a bug?** You can open a [GitHub issue](https://github.com/algolia/algoliasearch-client-swift/issues).
- **Questions about Algolia?** You can search our [FAQ in our website](https://www.algolia.com/doc/faq/).


## Getting involved

* If you **want to contribute** please feel free to **submit pull requests**.
* If you **have a feature request** please **open an issue**.
* If you use **InstantSearch** in your app, we would love to hear about it! Drop us a line on [discourse](https://discourse.algolia.com/) or [twitter](https://twitter.com/algolia).

# License

InstantSearch iOS is [Apache 2.0 licensed](LICENSE.md).

[react-instantsearch-github]: https://github.com/algolia/react-instantsearch/
[instantsearch-android-github]: https://github.com/algolia/instantsearch-android
[instantsearch-js-github]: https://github.com/algolia/instantsearch.js
[instantsearch-vue-github]: https://github.com/algolia/vue-instantsearch
[instantsearch-angular-github]: https://github.com/algolia/angular-instantsearch
