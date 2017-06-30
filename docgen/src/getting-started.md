---
title: Getting started
layout: main.pug
name: getting-started
category: main
withHeadings: true
navWeight: 100
editable: true
githubSource: docgen/src/getting-started.md
---

*This guide will walk you through the few steps needed to start a project with InstantSearch iOS.
We will start from an empty iOS project, and create from scratch a full search interface!*

## Before we start
To use InstantSearch iOS, you need an Algolia account. You can create one by clicking [here][algolia_sign_up], or use the following credentials:
- APP ID: `latency`
- Search API Key: `3d9875e51fbd20c7754e65422f7ce5e1`
- Index name: `bestbuy`

*These credentials will let you use a preloaded dataset of products appropriate for this guide.*

Another thing to point out is that this getting started guide will show you two ways of building your search experience: one is using storyboards (or xibs), and the other is writing your UI programatically. Depending on what your prefer, you can follow one track and ignore the other. 

## Create a new Project and add InstantSearch iOS
Let's get started! In Xcode, create a new Project:

- On the Template screen, select **Single View Application** and click next
- Specify your Product name, select Swift as the language, and iPhone as the Device. Then create.

We will use CocoaPods for adding the dependency to `InstantSearch`.

- If you don't have cocoapods installed on your machine, open your terminal and run `sudo gem install cocoapods`.
- Go to the root of your project then type `pod init`. A `Podfile` will be created for you.
- Open your `Podfile` and add `pod 'InstantSearch-Swift', '~> 1.0.0-beta5'` below your target.
- On your terminal, run `pod update`.
- Close you Xcode project and then at the root of your project, open `projectName.xcworkspace`.

## Initialization

To initialize InstantSearch, you need an Algolia account with a configured non-empty index. 

Go to your `AppDelegate.swift` file and then add `import InstantSearch` at the top. Then inside your `application(_:didFinishLaunchingWithOptions:)` method, add the following:

```swift
InstantSearch.shared.configure(appID: "latency", apiKey: "1f6fd3a6fb973cb08419fe7d288fa4db", index: "bestbuy_promo")
InstantSearch.shared.params.attributesToRetrieve = ["name", "salePrice"]
InstantSearch.shared.params.attributesToHighlight = ["name"]
```

This will initialize InstantSearch with the credentials proposed at the beginning. You can also chose to replace them with the credentials of your own app.

To understand the above, we are using the singleton `InstantSearch.shared` to configure InstantSearch with our Algolia credentials. `InstantSearch.shared` will be used throughout our app to easily deal with InstantSearch. You could also have created your own instance of `InstantSearch` and passed it around your controllers, but we won't do that in this guide.

Next, we added the attributes that we want to retrieve and highlight. As a side note, some search parameters can be defaulted in the Algolia dashboard by going to Indices -> Display tab. If you add the configuration there, then you do not need to specify the `attributesToRetrieve` and `attributesToHighlight` as shown above.

## Search your data: the SearchBar

<img src="assets/img/getting-started/guide-searchbar.png" width="200"/>

InstantSearch iOS is based on a system of [widgets][widgets] that communicate when a user interacts with your app. The first widget we'll add is a [SearchBar][widgets-searchbox] since any search experience requires one. InstantSearch will automatically recognize your SearchBar as a source of search queries. We will also add a `Stats` widget to show how the number of results change when you type a query in your SearchBar. 

### Option 1 - Programatically

Go to your `ViewController.swift` file and then add `import InstantSearch` at the top. Then, below your class definition, declare your [SearchBar][widgets-searchbox] and [Stats][widgets-stats] widget:

```swift
// Create your widgets
let searchBar = SearchBarWidget(frame: .zero)
let stats = StatsLabelWidget(frame: .zero)
```

Then inside your `viewDidLoad` method, add the following: 

```swift
initUI()
    
// Add all widgets to InstantSearch
InstantSearch.shared.registerAllWidgets(in: self.view)
```

Finally, we need to add the views to the `ViewController`'s view and specify the autolayout constraints so that the layout looks good on any device. You don't have to focus too much on understanding this part since it is not related to InstantSearch, and more related to iOS layout. Add this function to your file:

```swift
func initUI() {
    // Add the declared views to the main view
    self.view.addSubview(searchBar)
    self.view.addSubview(stats)
    
    // Add autolayout constraints
    searchBar.translatesAutoresizingMaskIntoConstraints = false
    stats.translatesAutoresizingMaskIntoConstraints = false
    
    let views = ["searchBar": searchBar, "stats": stats]
    var constraints = [NSLayoutConstraint]()
    constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-30-[searchBar]-10-[stats]", options: [], metrics: nil, views:views)
    constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-25-[searchBar]-25-|", options: [], metrics: nil, views:views)
    constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-25-[stats]-25-|", options: [], metrics: nil, views:views)
    NSLayoutConstraint.activate(constraints)
    
    // Style the stats label
    stats.textAlignment = .center
    stats.font = UIFont.boldSystemFont(ofSize:18.0)
}
```

### Option 2 - Storyboard

If you don't want to write your layout programatically, then follow this storyboard track. Go to your `ViewController.swift` file and then add `import InstantSearch` at the top. Then inside your `viewDidLoad` method, add the following: 

```swift    
// Register all widgets in view to InstantSearch
InstantSearch.shared.registerAllWidgets(in: self.view)
```

Here, we're telling InstantSearch to inspect all the subviews in the `ViewController`'s view. So what we need to do now is add the widgets to our view! 

So let's open our `Main.storyboard` and then on the Utility Tab on your right, Go to the Object Library on the bottom and then drag and drop a `Search Bar` to your view. Click on the `Search Bar` and then on the identity inspector, add the custom class `SearchBarWidget`. 

Now repeat the process but this time add a `Label` to the view, and then let the custom class be a `StatsLabelWidget`. Finally, make the width of the label bigger so that the text can clearly appear.

### Common

**Build and run your application: you now have the most basic search experience!** You should see that the results are changing on each key stroke. Fantastic!

### Recap

You just used your very first widgets from InstantSearch. In this part, you've learned:

- How to create a SearchBar Widget
- How to create a StatsLabel Widget
- How to register widgets to InstantSearch

## Display your data: Hits

<img src="assets/img/getting-started/guide-hits.png" width="200"/>

The whole point of a search experience is to display the dataset that matches best the query entered by the user. That's what we will implement in this section with the [hits][widgets-hits] widget.

### Option 1 - Programatically

We will now create our tableView. Next to your properties declared, add the following:

```swift
let tableView = HitsTableWidget(frame: .zero)
```

Then we will specify the layout constraint of the table to fill the most of the page. **Replace** your `initUI` method with the following (again, no need to worry about understanding this part):

```swift
func initUI() {
    // Add the declared views to the main view
    self.view.addSubview(searchBar)
    self.view.addSubview(stats)
    self.view.addSubview(tableView)
    
    // Add autolayout constraints
    searchBar.translatesAutoresizingMaskIntoConstraints = false
    stats.translatesAutoresizingMaskIntoConstraints = false
    tableView.translatesAutoresizingMaskIntoConstraints = false

    let views = ["searchBar": searchBar, "stats": stats, "tableView": tableView]
    var constraints = [NSLayoutConstraint]()
    constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-30-[searchBar]-10-[stats]-10-[tableView]-|", options: [], metrics: nil, views:views)
    constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-25-[searchBar]-25-|", options: [], metrics: nil, views:views)
    constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-25-[stats]-25-|", options: [], metrics: nil, views:views)
    constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-[tableView]-|", options: [], metrics: nil, views:views)
    NSLayoutConstraint.activate(constraints)
    
    // Register tableView identifier
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "hitCell")
    
    // Style the stats label
    stats.textAlignment = .center
    stats.font = UIFont.boldSystemFont(ofSize:18.0)
}
```

### Option 2 - Storyboard

If you don't want to write your layout programatically, then follow this storyboard track. In your `Main.Storyboard`, drag and drop a `Table View` from the Object Library and resize it to make it bigger. Then, select the `Table View` and change its custom class to `HitsTableWidget`. Now if you go to the attributes inspector, you will see that there are at the top 4 configuration parameters that you can apply like `Hits Pet Page` and `Infinite Scrolling`. Feel free to change them to your needs, or keep the default values.

Then, click on your `Table View`, and in the attributes inspector, add a prototype cell under the `Table View` section by replacing `0` with `1`. You should now be able to see a `Table View Cell` (under your `Table View`) in the Document Outline on the left of the storyboard file. Select that, and in the attributes inspector, specify `hitCell` as the identifier.

Finally, we need to have a reference to the `HitsTableView` in your `ViewController`. For that, go ahead and create an `IBOutlet` and call it `tableView`.

### Common

Now that we have our `Table View` setup, we still need to specify what fields from the Algolia response we want to show, as well as the layout of our cells. InstantSearch provides both base classes and helper classes in order to achieve this. Here, we will look at the easiest and most flexible way: using the base class.

In your `ViewController` class, replace `UIViewController` with `HitsTableViewController`. This class will help you setup a lot of boilerplate code for you. Next, in your `viewDidLoad` method after initializing the view and before adding your widgets to InstantSearch, add the following:

```swift
hitsTableView = tableView
```

This will associate the `hitsTableView` in the base class to the tableView that you just created. Behind the scenes, your `ViewController` class will become the `delegate` and `dataSource` of the tableView, the same way the UIKit base class `UITableViewController` does that for you.

Next, we can specify our cells with a method provided by the base class, which contains the hit for the specific row.

```swift
override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, containing hit: [String : Any]) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "hitCell", for: indexPath)
    
    cell.textLabel?.text = hit["name"] as? String
    
    return cell
}
```

Here we use the json hit, extract the `name` of the product, and assign it to the `text` property of the cell's `textLabel`.

<img src="assets/img/mvp/step1.png" class="img-object" align="right"/>

**Build and run your application: you now have an InstantSearch iOS app displaying your data!** You can also enjoy the infinite scrolling of the table as well if you set it to true!

In this part, you've learned:

- How to build your interface with Widgets by adding the `Hits` widget
- How to configure widgets
- How to specify the look and feel of your hit cells.

## Help the user understand your results: Highlighting

<img src="assets/img/getting-started/guide-highlighting.png" width="200"/>

Your application lets the user search and displays results, but doesn't explain _why_ these results match the user's query.

You can improve it by using the Highlighting feature: InstantSearchCore offers a helper method just for that. 
At the top of your file, add `import InstantSearchCore`. Then, in your `tableView(_:cellForRowAt:)` method, remove the statement `cell.textLabel?.text = hit["name"] as? String` as we don't need it anymore, and add the following before the `return cell` statement:


```swift
cell.textLabel?.highlightedTextColor = .blue
cell.textLabel?.highlightedBackgroundColor = .yellow
cell.textLabel?.highlightedText = SearchResults.highlightResult(hit: hit, path: "name")?.value
```

Restart your application and type something in the SearchBar: the results are displayed with your keywords highlighted in these views!

In this part, you've learned:

- Highlight search results

----

## Bonus - Let users filter their results: RefinementList

<img src="assets/img/getting-started/guide-refinementlist.png" width="200"/>

In this section, we give you the option to either go through a few instructions to write some boilerplate code for navigating between screens, or download a project that you can start with. This project contains the exact same thing that we just implemented, as well as the boilerplate code for navigating between screens. **We will only go through the storyboard approach in this section**. 

### Option 1 - Download Project

To get started, go ahead and clone this [repo](https://github.com/algolia/instantsearch-swift-examples), and then checkout branch `getting_started_refinement`. Go ahead and navigate to the `Getting Started Storyboard` project and then run `pod install`. Open the workspace project, and then run the app. You will see that we have the same app as before, with a Filter button at the top that navigates to your Refinement screen. 

### Option 2 - Setup New Screen and Navigation

First, go to File -> New -> File, then select Cocoa Touch Class, and name it RefinementViewController, then create it. 

Let's first setup the navigation controller. In your `Main.storyboard` file, click on your `ViewController`, then in your menu bar at the top, go to Editor -> Embed in -> Navigation Controller. Then, in your Utilities bar on your right, drag and drop a "View Controller" from the Object library to your storyboard. Click on it and then in the Identity Inspector, change its custom class to `RefinementViewController`. 

Now, In your Object library again, drag and drop a Bar Button Item to the Navigation bar of the first ViewController. Double click on it to change its name to "Filter". Then from this button, hold on Ctrl, and drag it to the `RefinementViewConroller` view, and select Show as the Action Segue. 

Next, drag and drop a Table View from the Object Library onto the `RefinementViewController` view, and change its custom class to be `RefinementTableWidget`. Go ahead and create a prototype cell for this table and specify `refinementCell` as the identifier. Then, create an `IBOutlet` of that tableView into RefinementViewController.swift, and call it `tableView`.

Finally, add the `import InstantSearch` statement at the top of RefinementViewController.swift.

### Common - RefinementList

We can implement a [RefinementList][widgets-refinementlist] with the exact same idea as the Hits widgets: using a base class and then implementing some delegate methods. However, this time, we will implement it using the helper class in order to show you how things can be done differently. That will help you use InstantSearch in the case where your `ViewController` already inherits from a subclass of `UIViewController`, and not `UIViewController` itself. Also, since you cannot subclass a Swift class in Objective-C, then this method will be useful if you decide to write your app in Objective-C. 

First things first, go to `Main.Storyboard` and then select the `tableView` in the screen containing your `refinementList`. This will be your `refinementList`. Note that we already changed the class of the table to be a `RefinementTableWidget`. Now, go to the Attributes Inspector pane and then at the top, specify the `attribute` to be equal to `category`. This will associate the `refinementList` with the attribute `category`.

Next, go to the `RefinementViewController.swift` class, and then add protocol `, RefinementTableViewDataSource` next to `UIViewController`. Then, add the following property below the declared `tableView`:

```swift
var refinementController: RefinementController!
```

This `refinementController` will take care of the `dataSource` and `delegate` methods of the `tableView`, and will provide other advanced `dataSource` and `delegate` methods that contain information about the refinement. To achieve that, add the following in your `viewDidLoad` method:

```swift
refinementController = RefinementController(table: tableView)
tableView.dataSource = refinementController
tableView.delegate = refinementController
refinementController.tableDataSource = self
// refinementController.tableDelegate = self
    
InstantSearch.shared.register(widget: tableView)
```
Remember at the end to always register the widget to `InstantSearch` so that it receives interesting search events from it. Finally, we need to add our dataSource method to specify the look and feel of the refinementList cell.

```swift
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, containing facet: String, with count: Int, is refined: Bool) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "refinementCell", for: indexPath)
    
    cell.textLabel?.text = facet
    cell.detailTextLabel?.text = String(count)
    cell.accessoryType = refined ? .checkmark : .none
    
    return cell
}
```
We're done! **Build and run your application: you now have an InstantSearch iOS app that can filter data!**. Click on Filter and select refinements then go back. You will see that the stats and hits widget automatically update with the new data. Sweet! You can also go to your `Main.storyboard` and play around with the custom parameters of each widgets which are available in the attributes inspector.

In this part, you've learned:

- How to add the `RefinementList` widget
- How to configure the widget
- How to specify the look and feel of your refinement cells.

## Go further

Your application now displays your data, lets your users enter a query, displays search results as-they-type and lets users filter by refinements: you just built a full instant-search interface! Congratulations 🎉

This is only an introduction to what you can do with InstantSearch iOS: have a look at our [examples][examples] to see more complex examples of applications built with InstantSearch.
You can also head to our [Widgets page][widgets] to see the other components that you could use.

[algolia_sign_up]: https://www.algolia.com/users/sign_up
[widgets]: widgets.html
[examples]: examples.html
[widgets-hits]: widgets.html#hits
[widgets-searchbox]: widgets.html#searchbar
[widgets-refinementlist]: widgets.html#refinementlist
[widgets-stats]: widgets.html#stats