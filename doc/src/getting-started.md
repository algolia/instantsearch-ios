---
title: Getting started
layout: main.pug
name: getting-started
category: main
withHeadings: true
navWeight: 100
---

*This guide will walk you through the few steps needed to start a project with InstantSearch iOS.
We will start from an empty iOS project, and create from scratch a full search interface!*

## Before we start
To use InstantSearch iOS, you need an Algolia account. You can create one by clicking [here](https://www.algolia.com/users/sign_up), or use the following credentials:
- APP ID: `latency`
- Search API Key: `3d9875e51fbd20c7754e65422f7ce5e1`
- Index name: `bestbuy`

*These credentials will let you use a preloaded dataset of products appropriate for this guide.*

Another thing to point out is that this getting started guide will show you two ways of building your search experience: one is using storyboards (or xibs), and the other is writing your UI programatically. Depending on what your prefer, you can follow one track and ignore the other. 

## Create a new Project and add InstantSearch iOS
In Xcode, create a new Project:

- On the Template screen, select **Single View Application** and click next
- Specify your Product name, select Swift as the language, and iPhone as the Device. Then create.

We will use CocoaPods for adding the dependency to `InstantSearch`.

- Open your terminal and run `sudo gem install cocoapods` if you don't have cocoapods installed on your machine.
- Go to the root of your project then type `pod init`. A `Podfile` will be created for you.
- Open your `Podfile` and add `pod 'AlgoliaSearch-InstantSearch-Swift', '~> 0.1.0'` below your target.
- On your terminal, run `pod install`.
- Close you Xcode project and then at the root of your project, open `projectName.xcworkspace`.

## Initialization

To initialize InstantSearch, you need an Algolia account with a configured and non-empty index. 

Go to your `AppDelegate.swift` file and then add `import InstantSearch` at the top. Then inside your `didFinishLaunchingWithOptions:` method, add the following:

```swift
InstantSearch.reference.configure(appID: "latency", apiKey: "1f6fd3a6fb973cb08419fe7d288fa4db", index: "bestbuy_promo")
InstantSearch.reference.params.attributesToRetrieve = ["name", "salePrice"]
InstantSearch.reference.params.attributesToHighlight = ["name"]
```

This will initialize InstantSearch with the credentials proposed at the beginning. You can also chose to replace them with the credentials of your own app.

To understand the above, we are using the singleton `InstantSearch.reference` to configure InstantSearch with our Algolia credentials. `InstantSearch.reference` will be used throughout our app to easily deal with InstantSearch. Note that you can also create your own instance of `InstantSearch` and pass it around your Controllers, but we won't do that in this guide.

Next, we added the attributes that we want to retrieve and highlight. Note that this can be specified in the Algolia dashboard by going to Indices -> Display tab. If you added the configuration there, then you do not need to specify the `attributesToRetrieve` and `attributesToHighlight` as shown above.

## Search your data: the SearchBar

InstantSearch iOS is based on a system of [widgets][widgets] that communicate when a user interacts with your app. The first widget we'll add is a SearchBar since any search experience requires one. InstantSearch will automatically recognize your SearchBar as a source of search queries. We will also add a `Stats` widget to show how the number of results change when you type a query in your SearchBar. 

### Programatically

Go to your `ViewController.swift` file and then add `import InstantSearch` at the top. Then inside your `viewDidLoad` method, add the following: 

```swift
// Create your Search and Stat widget.
let searchBar = SearchBarWidget(frame: CGRect(x: 10, y: 30, width: self.view.frame.width - 20, height: 40))
let statsWidget = StatsLabelWidget(frame: CGRect(x: 10, y: 75, width: 150, height: 50))

// Add them to the ViewController's view.
self.view.addSubview(searchBar)
self.view.addSubview(statsWidget)
    
// Add all widgets to InstantSearch
InstantSearch.reference.addAllWidgets(in: self.view)
```

### Storyboard

Go to your `ViewController.swift` file and then add `import InstantSearch` at the top. Then inside your `viewDidLoad` method, add the following: 

```swift    
// Add all widgets in view to InstantSearch
InstantSearch.reference.addAllWidgets(in: self.view)
```

Here, we're telling InstantSearch to inspect all the subviews in the `ViewController`'s view. So what we need to do now is add the widgets to our view! 

So let's open our `Main.storyboard` and then on the Utility Tab on your right, Go to the Object Library on the bottom and then drag a drop a `Search Bar` to your view. Click on the `Search Bar` and then on the identity inspector, add the custom class `SearchBarWidget`. 

Now repeat the process but this time add a `Label` to the view, and then let the custom class be a `StatsLabelWidget`. Finally, make the width of the label bigger so that the text appears clearly.

### Common

Run your app with `Cmd` + `r`, and then search in the SearchBar on the screen. You should see that the results are changing on each key stroke. Nice stuff with so little code!

### Recap

Fantastic! You just used your very first widgets from InstantSearch.

In this part, you've learned:

- How to create a SearchBar Widget
- How to create a StatsLabel Widget
- How to add widgets to InstantSearch

## Display your data: Hits

The whole point of a search experience is to display the dataset that matches best the query entered by the user. That's what we will implement in this section 

### Programatically

// TODO: need to see how to specify identifier here.

### Storyboard

In your `Main.Storyboard`, drag and drop a `Table View` from the Object Library and resize it to make it bigger. Then, select the `Table View` and change its custom class to `HitsTableWidget`. Now if you go to the identity inspector, you will see that there are at the top 4 configuration parameters that you can apply like `Hits Pet Page` and `Infinite Scrolling`. Feel free to change them to your needs, or keep the default values.

After that, click on your tableView, and in the identity inspector, add a prototype cell. Then, select the Table View Cell and in the identity inspector, specify `hitCell` as the identifier.

Next, we need to have a reference to this HitsTableView in your `ViewController`. For that, go ahead and create an `IBOutlet` and call it `tableView`.

### Common

Now that we have our `Table View` setup, we still need to specify what fields from the Algolia response we want to show, as well as the layout of our cells. InstantSearch provides both base classes and helper classes in order to achieve this. Here, we will look at the easiest and most flexible way: using the base class.

In your `ViewController` class, replace `UIViewController` with `HitsTableViewController`. This class will help you setup a lot of boilerplate code for you. Next, in your `viewDidLoad` method and before adding your widgets to InstantSearch, add the following:

```swift
hitsTableView = tableView
```

This will associate the `hitsTableView` in the base class to the tableView that you just created. Behind the scenes, your `ViewController` class will become the `delegate` and `dataSource` of the tableView, the same way the UIKit base class `UITableViewController` does that for you.

Next, we can specify our cells with a method provided by the base class, which contains the hit for the specific row.

```swift
override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, containing hit: [String : Any]) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "hitCell", for: indexPath)
    
    cell.textLabel?.text = hit["name"] as? String
    cell.detailTextLabel?.text = String(hit["salePrice"] as! Double)
    
    return cell
}
```

Here we use the json hit, extract the `name` and `salePrice`, and assign it to the `text` property of the labels.

<img src="assets/img/mvp/step1.png" class="img-object" align="right"/>

**Build and run your application: you now have an InstantSearch iOS app displaying your data!**

<p class="cb">In this part you've learned:</p>

- How to build your interface with Widgets by adding the `Hits` widget
- How to configure widgets
- How to specify the look and feel of your cells.

## Help the user understand your results: Highlighting

<img src="assets/img/mvp/step2.png" class="img-object" align="right"/>

Your application lets the user search and displays results, but doesn't explain _why_ these results match the user's query.

You can improve it by using the [Highlighting][highlighting] feature: just add `algolia:highlighted="@{true}"` to every Views where the query should be highlighted:

```xml
<TextView
    iOS:id="@+id/product_name"
    iOS:layout_width="wrap_content"
    iOS:layout_height="wrap_content"
    algolia:attribute='@{"name"}'
    algolia:highlighted='@{true}'/>
```

<br />

Restart your application and type something in the SearchBox: the results are displayed with your keywords highlighted in these Views!

<!-- TODO: Add Filtering when RefinementList is a mobile-ready component
## Filter your data: the RefinementList
-->


You now know how to:
- Add a search input with the `SearchBox` widget
- Highlight search results with `algolia:highlighted`

----


## Go further

Your application now displays your data, lets your users enter a query and displays search results as-they-type: you just built an instant-search interface! Congratulations 🎉

This is only an introduction to what you can do with InstantSearch iOS: have a look at our [examples][examples] to see more complex examples of applications built with InstantSearch.
You can also head to our [Widgets page][widgets] to see the other components that you could use.

[examples]: examples.html
[widgets]: widgets.html
[widgets-hits]: widgets.html#hits
[widgets-searchbox]: widgets.html#hits
[dbl]: https://developer.iOS.com/topic/libraries/data-binding/index.html
[searcher]: concepts.html#searcher
[instantsearchhelper]: concepts.html#instantsearchhelper
[highlighting]: widgets.html#highlighting
[doc-instantsearch-search]: javadoc/com/algolia/instantsearch/ui/InstantSearchHelper.html#search--
