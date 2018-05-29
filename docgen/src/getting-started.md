---
title: Getting Started
layout: main.pug
name: getting-started
category: main
withHeadings: true
navWeight: 100
editable: true
githubSource: docgen/src/getting-started.md
---

*This guide will walk you through the few steps needed to start a project with InstantSearch iOS.
We will start from an empty iOS project, and then create from scratch a full search interface!*

*Another thing to point out is that this getting started guide will show you how to build your search experience using storyboards (or xibs). However, if you prefer to write your UI programatically, you can follow the [programmatic getting started guide](getting-started-programmatic.html).*

## Before we start
To use InstantSearch iOS, you need an Algolia account. You can create one by clicking [here][algolia_sign_up], or use the following credentials:
- APP ID: `latency`
- Search API Key: `1f6fd3a6fb973cb08419fe7d288fa4db`
- Index name: `bestbuy_promo`

*These credentials will let you use a preloaded dataset of products appropriate for this guide.*

## Create a new project
Let's get started! In Xcode, create a new Project:

- On the Template screen, select **Single View Application** and click next
- Specify your Product name, select Swift as the language, and iPhone as the Device. Then create.

<br/>
<img src="assets/img/getting-started/xcode-newproject.png" />
<br/>
<br/>

We will use CocoaPods for adding the dependency to `InstantSearch`.

- If you don't have CocoaPods installed on your machine, open your terminal and run `sudo gem install cocoapods`.
- Go to the root of your project then type `pod init`. A `Podfile` will be created for you.
- Open your `Podfile` and add `pod 'InstantSearch'` below your target.
- On your terminal, run `pod update`.
- Close you Xcode project and then at the root of your project, open `projectName.xcworkspace`.

## Initialize InstantSearch

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

## Search your data: SearchBar

<img src="assets/img/getting-started/guide-searchbar.png" class="img-object" align="right"/>

InstantSearch iOS is based on a system of [widgets][widgets] that constitute your search interface. The first widget we'll add is a [SearchBar][widgets-searchbox] since any search experience requires one. InstantSearch will automatically recognize your SearchBar as a source of search queries. We will also add a `Stats` widget to show how the number of results change when you type a query in your SearchBar. 

- Start by going to your `ViewController.swift` file and then add `import InstantSearch` at the top. 
- Then inside your `viewDidLoad` method, add the following: 

```swift    
// Register all widgets in view to InstantSearch
InstantSearch.shared.registerAllWidgets(in: self.view)
```

Here, we're telling InstantSearch to inspect all the subviews in the `ViewController`'s view. So what we need to do now is add the widgets to our view! 

- Open your `Main.storyboard` file, and on the Utility Tab on your right, go to the Object Library at the bottom.
- Drag and drop a `Search Bar` to your view. Click on it and then on the identity inspector, add the custom class `SearchBarWidget`. 
- Now repeat the process but this time add a `Label` to the view, and then let the custom class be a `StatsLabelWidget`.
- Finally, make the width of the label bigger so that the text can clearly appear.

<br/>
<img src="assets/img/getting-started/xcode-searchbar.png" width="800"/>
<br/>
<br/>

**Build and run your application: you now have the most basic search experience!** You should see that the results are changing on each key stroke. Fantastic!

### Recap

You just used your very first widgets from InstantSearch. In this part, you've learned:

- How to create a SearchBar Widget.
- How to create a StatsLabel Widget.
- How to register widgets to InstantSearch.

## Display your data: Hits

<img src="assets/img/getting-started/guide-hits.png" class="img-object" align="right"/>

The whole point of a search experience is to display the dataset that matches best the query entered by the user. That's what we will implement in this section with the [hits][widgets-hits] widget.

- In your `Main.Storyboard`, drag and drop a `Table View` from the Object Library and resize it to make it bigger.
- Select the `Table View` and change its custom class to `HitsTableWidget`.



> *If you go to the attributes inspector, you will see that at the top, there are 4 configuration parameters that you can change, like `Hits Pet Page` and `Infinite Scrolling`. Feel free to change them to your needs, or keep the default values.*

<p align="center">
<img src="assets/img/getting-started/xcode-configurewidgets.png" />
</p>

- Click on your `Table View`, and in the attributes inspector, add a prototype cell under the `Table View` section by replacing `0` with `1`.
- You should now be able to see a `Table View Cell` (under your `Table View`) in the Document Outline on the left of the storyboard file. Select that, and in the attributes inspector, specify `hitCell` as the identifier.
- Finally, we need to have a reference to the `HitsTableView` in your `ViewController`. For that, go ahead and create an `IBOutlet` and call it `tableView`.

<br/>
<img src="assets/img/getting-started/xcode-hits.png" width="800"/>
<br/>
<br/>

Now that we have our `Table View` setup, we still need to specify what fields from the Algolia response we want to show, as well as the layout of our cells. InstantSearch provides both base classes and helper classes in order to achieve this. Here, we will look at the easiest and most flexible way: using the base class `HitsTableViewController`.

- In your `ViewController` class, replace `UIViewController` with `HitsTableViewController`. This class will help you setup a lot of boilerplate code for you.
- Next, in your `viewDidLoad` method, before registering your widgets to InstantSearch, add the following:

```swift
hitsTableView = tableView
```

This will associate the `hitsTableView` in the base class to the `tableView` that we just created. Behind the scenes, your `ViewController` class will become the `delegate` and `dataSource` of the tableView, the same way the UIKit base class `UITableViewController` does that for you.

Next, we can specify our cells with a method provided by the base class, which contains the hit for the specific row.

```swift
override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, containing hit: [String : Any]) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "hitCell", for: indexPath)
    
    cell.textLabel?.text = hit["name"] as? String
    
    return cell
}
```

Here we use the json hit, extract the `name` of the product, and assign it to the `text` property of the cell's `textLabel`.

**Build and run your application: you now have an InstantSearch iOS app displaying your data!** You can also enjoy the infinite scrolling of the table as well if you set it to true!

In this part, you've learned:

- How to build your interface with widgets by adding the `Hits` widget.
- How to configure widgets.
- How to specify the look and feel of your hit cells.

## Go Further

Your application now displays your data, lets your users enter a query and displays search results as-they-type. That is pretty nice already! However, we can go further and improve on that. 

- In the [getting started part 2](getting-started-part2.html), you will learn about properly highlighting results, as well as filtering results which is essential for a complete search experience. Finally, you will see how you can target multiple indices.
- You can also have a look at our [examples][examples] to see more complex examples of applications built with InstantSearch.
- Finally, You can head to our [widgets page][widgets] to see other components that you could use.

[algolia_sign_up]: https://www.algolia.com/users/sign_up
[widgets]: widgets.html
[examples]: examples.html
[widgets-hits]: widgets.html#hits
[widgets-searchbox]: widgets.html#searchbar
[widgets-refinementlist]: widgets.html#refinementlist
[widgets-stats]: widgets.html#stats