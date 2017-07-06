---
title: Getting Started Part 2
layout: main.pug
name: getting-started-part2
category: main
withHeadings: true
navWeight: 100
editable: true
githubSource: docgen/src/getting-started-part2.md
---

*This guide is a followup to the [first part of the getting started guide](getting-started.html). Make sure to go through it first before moving to this one.*

*This guide will walk you through how to properly highlight results, as well as filter results which is essential for a complete search experience.*

## Setup

Your starting project can be one of the following: 

- The project you used in the [getting started part 1](getting-started.html)
- Download this project as a starting point and run `pod install`.

## Highlight your results

<img src="assets/img/getting-started/guide-highlighting.png" class="img-object" align="right"/>

Your current application lets the user search and displays results, but doesn't explain _why_ these results match the user's query.

You can improve it by using the Highlighting feature: InstantSearchCore offers a helper method just for that. 
At the top of your file, add `import InstantSearchCore`. Then, in your `tableView(_:cellForRowAt:)` method, remove the statement `cell.textLabel?.text = hit["name"] as? String` as we don't need it anymore, and add the following before the `return cell` statement:


```swift
cell.textLabel?.highlightedTextColor = .blue
cell.textLabel?.highlightedBackgroundColor = .yellow
cell.textLabel?.highlightedText = SearchResults.highlightResult(hit: hit, path: "name")?.value
```

Restart your application and type something in the SearchBar: the results are displayed with your keywords highlighted in these views!

In this part, you've learned:

- Highlighting search results

----

## Filter your results: RefinementList

<img src="assets/img/getting-started/guide-refinementlist.png" class="img-object" align="right"/>

In this section, we give you the option to either go through a few instructions to write some boilerplate code for navigating between screens, or download a project that you can start with. This project contains the exact same thing that we just implemented, as well as the boilerplate code for navigating between screens. **We will only go through the storyboard approach in this section**. 

### Setup New Screen and Navigation

First, go to File -> New -> File, then select Cocoa Touch Class, and name it RefinementViewController, then create it. 

Let's first setup the navigation controller. In your `Main.storyboard` file, click on your `ViewController`, then in your menu bar at the top, go to Editor -> Embed in -> Navigation Controller. Then, in your Utilities bar on your right, drag and drop a "View Controller" from the Object library to your storyboard. Click on it and then in the Identity Inspector, change its custom class to `RefinementViewController`. 

Now, In your Object library again, drag and drop a Bar Button Item to the Navigation bar of the first ViewController. Double click on it to change its name to "Filter". Then from this button, hold on Ctrl, and drag it to the `RefinementViewConroller` view, and select Show as the Action Segue. 

Next, drag and drop a Table View from the Object Library onto the `RefinementViewController` view, and change its custom class to be `RefinementTableWidget`. Go ahead and create a prototype cell for this table and specify `refinementCell` as the identifier. Then, create an `IBOutlet` of that tableView into `RefinementViewController.swift`, and call it `tableView`.

Finally, add the `import InstantSearch` statement at the top of `RefinementViewController.swift`.

### The RefinementList

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