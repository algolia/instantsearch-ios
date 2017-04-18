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




## Introduction

InstantSearch iOS is a library providing widgets and helpers to help you build the best instant-search experience on iOS with Algolia. It is built on top of Algolia's [Swift API Client](https://github.com/algolia/algoliasearch-client-swift) to provide you a high-level solution to quickly build various search interfaces.

<!-- <img src="Example/InstantSearch.gif" width="300"/> -->

## Architecture of InstantSearch

InstantSearch is inspired by both MVVM and VIPER architecture. 

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

The Binder plays a role of exposing all possible search events, whether from the Searcher or other widgets,
and making them available for ViewModels or Views so that they can tune in.
In a way, it is like an observable that knows about all search events, and it will send the search events to 
the observers that decided to tune in. We decided to go with delegation to offer a clean safe interface.
It also makes sure to call the Builder methods on the Widgets that fit case 1 mentioned above

The Builder plays the role of spinning up the WidgetVM for the WidgetV, takes care of injecting the concrete implementations into the WidgetV and the WidgetVM, and finally links the delegates of the WidgetV, WidgetVM and the Searcher

## Usage

```swift
import InstantSearch
..
.
```

## Requirements

* iOS 9.0+
* Xcode 8.0+

## Getting involved

* If you **want to contribute** please feel free to **submit pull requests**.
* If you **have a feature request** please **open an issue**.
* If you **found a bug** or **need help** please **check older issues, [FAQ](#faq) and threads on [StackOverflow](http://stackoverflow.com/questions/tagged/InstantSearch) (Tag 'InstantSearch') before submitting an issue.**.

Before contribute check the [CONTRIBUTING](https://github.com/algolia/InstantSearch/blob/master/CONTRIBUTING.md) file for more info.

If you use **InstantSearch** in your app We would love to hear about it! Drop us a line on [twitter](https://twitter.com/algolia).

## Examples

Follow these 3 steps to run Example project: Clone InstantSearch repository, open InstantSearch workspace and run the *Example* project.

You can also experiment and learn with the *InstantSearch Playground* which is contained in *InstantSearch.workspace*.

## Installation

#### CocoaPods

[CocoaPods](https://cocoapods.org/) is a dependency manager for Cocoa projects.

To install InstantSearch, simply add the following line to your Podfile:

```ruby
pod 'InstantSearch', '~> 1.0'
```

#### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a simple, decentralized dependency manager for Cocoa.

To install InstantSearch, simply add the following line to your Cartfile:

```ogdl
github "algolia/InstantSearch" ~> 1.0
```

## Author

* [Algolia](https://github.com/algolia) ([@algolia](https://twitter.com/algolia))

## FAQ

#### How to .....

You can do it by conforming to .....

# Change Log

This can be found in the [CHANGELOG.md](CHANGELOG.md) file.
