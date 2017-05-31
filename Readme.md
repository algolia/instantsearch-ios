# InstantSearch

<p align="left">
<a href="https://travis-ci.org/algolia/InstantSearch"><img src="https://travis-ci.org/algolia/InstantSearch.svg?branch=master" alt="Build status" /></a>
<img src="https://img.shields.io/badge/platform-iOS-blue.svg?style=flat" alt="Platform iOS" />
<a href="https://developer.apple.com/swift"><img src="https://img.shields.io/badge/swift3-compatible-4BC51D.svg?style=flat" alt="Swift 3 compatible" /></a>
<a href="https://github.com/Carthage/Carthage"><img src="https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat" alt="Carthage compatible" /></a>
<a href="https://cocoapods.org/pods/XLActionController"><img src="https://img.shields.io/cocoapods/v/InstantSearch.svg" alt="CocoaPods compatible" /></a>
<a href="https://raw.githubusercontent.com/algolia/InstantSearch/master/LICENSE"><img src="http://img.shields.io/badge/license-MIT-blue.svg?style=flat" alt="License: MIT" /></a>
</p>

By [Algolia](http://algolia.com).


## Warning

**This repo is a WIP**. Do not use it in production as the APIs can still change. Stay tuned for a beta release soon :)

## Introduction

InstantSearch iOS is a library providing widgets and helpers to help you build the best instant-search experience on iOS with Algolia. It is built on top of Algolia's [Swift API Client](https://github.com/algolia/algoliasearch-client-swift) to provide you a high-level solution to quickly build various search interfaces.

<!-- <img src="Example/InstantSearch.gif" width="300"/> -->

## Usage

```swift
import InstantSearch

// Configure InstantSearch AppDelegate 
InstantSearch.reference.configure(appID: APP_ID, apiKey: API_KEY, index: INDEX)

// Declare your widgets (IB or programatically) in your ViewController
let searchBar = SearchBarWidget(frame: CGRect(...))
let statsWidget = StatsLabelWidget(frame: CGRect(...))
self.view.addSubview(searchBar)
self.view.addSubview(statsWidget)

// Add all widgets in view to InstantSearch in your ViewController
InstantSearch.reference.addAllWidgets(in: self.view)

// Run your app and write a query in the searchBar.
```

## Requirements

* iOS 9.0+
* Xcode 8.0+

## Getting involved

* If you **want to contribute** please feel free to **submit pull requests**.
* If you **have a feature request** please **open an issue**.
* If you **found a bug** or **need help** please **check older issues, [FAQ](#faq) and threads on [StackOverflow](http://stackoverflow.com/questions/tagged/Algolia) (Tag 'Algolia') before submitting an issue.**.

Before contribute check the [CONTRIBUTING](https://github.com/algolia/InstantSearch/blob/master/CONTRIBUTING.md) file for more info.

If you use **InstantSearch** in your app, we would love to hear about it! Drop us a line on [discourse](https://discourse.algolia.com/) or [twitter](https://twitter.com/algolia).

## Examples

Follow these 3 steps to run Example project: Clone InstantSearch repository, open InstantSearch workspace and run the *Example* project.

You can also experiment and learn with the *InstantSearch Playground* which is contained in *InstantSearch.workspace*.

## Installation

#### CocoaPods

[CocoaPods](https://cocoapods.org/) is a dependency manager for Cocoa projects.

To install InstantSearch, simply add the following line to your Podfile:

```ruby
pod 'InstantSearch-Swift', '~> 1.0.0-beta1'
```

#### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a simple, decentralized dependency manager for Cocoa.

To install InstantSearch, simply add the following line to your Cartfile:

```ogdl
github "algolia/InstantSearch-ios" ~> 1.0.0-beta1
```

## Author

* [Algolia](https://github.com/algolia) ([@algolia](https://twitter.com/algolia))

## FAQ

#### Where can I search for general questions about Algolia?
You can search our [FAQ in our website](https://www.algolia.com/doc/faq/).

# Change Log

This can be found in the [CHANGELOG.md](CHANGELOG.md) file.
