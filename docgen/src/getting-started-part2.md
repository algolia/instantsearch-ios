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
- Download [this project](https://github.com/algolia/instantsearch-swift-examples/tree/master/Getting%20Started%20Part%202%20Start) as a starting point and run `pod update`.

## Highlight your results

<img src="assets/img/getting-started/guide-highlighting.png" class="img-object" align="right"/>

Your current application lets the user search and displays results, but doesn't explain _why_ these results match the user's query.

You can improve it by using the Highlighting feature: InstantSearchCore offers a helper method just for that. 
- At the top of your file, add `import InstantSearchCore`. 
- In your `tableView(_:cellForRowAt:)` method, remove the statement `cell.textLabel?.text = hit["name"] as? String` as we don't need it anymore, and add the following before the `return cell` statement:


```swift
cell.textLabel?.highlightedTextColor = .blue
cell.textLabel?.highlightedBackgroundColor = .yellow
cell.textLabel?.highlightedText = SearchResults.highlightResult(hit: hit, path: "name")?.value
```

Restart your application and type something in the SearchBar: the results are displayed with your keywords highlighted in these views!

In this part, you've learned:

- Highlighting search results.

----

## Filter your results: RefinementList

<img src="assets/img/getting-started/guide-refinementlist.png" class="img-object" align="right"/>

A refinementList lets the user refine the search results by choosing filters from a list of filters. In this section, we will build a refinementList to filter results based on the categories selected. **We will only go through the storyboard approach here**. 

### Setup New Screen and Navigation

- Go to File -> New -> File, then select Cocoa Touch Class, and name it RefinementViewController, then create it. 
- Let's first setup the navigation controller. In your `Main.storyboard` file, click on your `ViewController`, then in your menu bar at the top, go to Editor -> Embed in -> Navigation Controller. 
- In your Utilities bar on your right, drag and drop a `View Controller` from the Object library to your storyboard. Click on it and then in the Identity Inspector, change its custom class to `RefinementViewController`. 
- In your Object library again, drag and drop a `Bar Button Item` to the Navigation bar of the first ViewController. Double click on it to change its name to "Filter". 
- From this button, hold on Ctrl, and drag it to the `RefinementViewConroller` view, and select `Show` as the Action Segue. 

Now that we have our navigation setup, let's add our refinementList as a `tableView`.

* Drag and drop a Table View from the Object Library onto the `RefinementViewController` view, and change its custom class to be `RefinementTableWidget`. Go ahead and create a prototype cell for this table and specify `refinementCell` as the identifier. Also, change the `Style` of the cell in the identity inspector to `Subtitle`.
* Then, create an `IBOutlet` of that tableView into `RefinementViewController.swift`, and call it `tableView`.
* Finally, add the `import InstantSearch` statement at the top of `RefinementViewController.swift`.

<br/>
<img src="assets/img/getting-started/xcode-refinementlist.png" width="800"/>
<br/>
<br/>

### The RefinementList

We can implement a [RefinementList][widgets-refinementlist] with the exact same idea as the Hits widgets: using a base class and then implementing some delegate methods. However, this time, we will implement it using the helper class in order to show you how things can be done differently. That will help you use InstantSearch in the case where your `ViewController` already inherits from a subclass of `UIViewController`, and not `UIViewController` itself. Also, since you cannot subclass a Swift class in Objective-C, then this method will be useful if you decide to write your app in Objective-C. 

- First things first, go to `Main.Storyboard` and then select the `tableView` in the screen containing your `refinementList`. This will be your `refinementList`. Note that we already changed the class of the table to be a `RefinementTableWidget`. 
- Now, go to the Attributes Inspector pane and then at the top, specify the `attribute` to be equal to `category`. This will associate the `refinementList` with the attribute `category`.
- Next, go to the `RefinementViewController.swift` class, and then add protocol `, RefinementTableViewDataSource` next to `UIViewController`. 
- Add the following property below the declared `tableView`:

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

- How to add the `RefinementList` widget.
- How to configure the widget.
- How to specify the look and feel of your refinement cells.

## Display data from multiple hits

It is probable that your app is targeting multiple indices: for example, you want to search through bestbuy items, as well as IKEA items. Let's see how this is possible.

First make sure that you're using the latest version of InstantSearch (after 2.1.0).

### Code

In order to specify to InstantSearch which index you want to target, go to your `AppDelegate` and then inside your `application(_:didFinishLaunchingWithOptions:)` method, replace what is in it with:

```swift
let searcherIds = [SearcherId(index: "bestbuy_promo"), SearcherId(index: "ikea")]
InstantSearch.shared.configure(appID: ALGOLIA_APP_ID, apiKey: ALGOLIA_API_KEY, searcherIds: searcherIds)
```

In that way, InstantSearch is aware of the indices that it has to deal with. Next, go to your `ViewController` and replace all of it with the following: 

```swift
import UIKit
import InstantSearch
import InstantSearchCore

class HitsViewController: MultiHitsTableViewController {

    @IBOutlet weak var tableView: MultiHitsTableWidget!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        hitsTableView = tableView
        
        InstantSearch.shared.registerAllWidgets(in: self.view)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, containing hit: [String : Any]) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "hitCell", for: indexPath)
        
        if indexPath.section == 0 { // bestbuy
            cell.textLabel?.highlightedTextColor = .blue
            cell.textLabel?.highlightedBackgroundColor = .yellow
            cell.textLabel?.highlightedText = SearchResults.highlightResult(hit: hit, path: "name")?.value
        } else { // ikea
            cell.textLabel?.highlightedTextColor = .white
            cell.textLabel?.highlightedBackgroundColor = .black
            cell.textLabel?.highlightedText = SearchResults.highlightResult(hit: hit, path: "name")?.value
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 30))
        
        let view = UIView()
        view.addSubview(label)
        view.backgroundColor = UIColor.gray
        return view
    }
}
```

Things to note: 

First, from the previous single-index implementation, we changed some classes from `HitsXYZ` to `MultiHitsXYZ`. These are `MultiHitsTableViewController` and `MultiHitsTableWidget`, 
Nothing changed in the `ViewDidLoad`, and in the `cellForRowAt` method, we now have to deal with 2 sections since we'll have one for bestbuy, and one for ikea. Finally, we specify a `viewForHeaderInSection` to put a separator between these 2 sections.

### Storyboard

Now, head into the `Main.Storyboard`, select your stat widget, and then in the property inspector, add `ikea` to the `index` field. This specifies that the stats label shows number of results for ikea products. Next, click on the tableView which show the hits, and then in the identity inspector, change the class to `MultiHitsTableWidget`. Then, head to the identity inspector and specify the following:

- Indices: `bestbuy_promo,ikea`
- Hits Per Section: `5,10`

Here, we are saying that we want to show the `bestbuy_promo` index in the first section and the `ikea` index in the second. 
We also specify that we want 5 hits to appear for the `bestbuy_promo` index and 10 for the `ikea` index.

Great, now **run your app**, search in the search bar and you should see results appearing from the indices!

There's still one more thing: If you click on the filter button, **the app will crash**. Why is that? This is because we are in "multi-index" mode and the refinement list doesn't have a clue what index to target: is it bestbuy_promo or ikea? 

In order to specify this, go to your `main.storyboard` class, then click on the refinement list. In the attribute inspector, specify `bestbuy_promo` as the index.

Now go ahead and **run your app again**. When going to the filters screen and selecting a filter, you'll notice in the main screen that the refinements are only being applied to the `bestbuy_promo` index.

In this part, you've learned:

- How to configure InstantSearch for Multi-indexing.
- How to use the `MultiHitsTableWidget` which can show different indices.
- How to specify an index for widgets such as the `StatsLabelWidget` and the `RefinementTableWidget`.

### Notes

- You might have seen `Variant` or `Variants` attributes in the identity inspector (variants example: `main,details`). These are used in case you want 2 widgets to use the same index but with different configurations. You also have to specify those variants when configuring InstantSearch using the `SearcherId(index:variant)` constructor instead of `SearcherId(index:)`.
- Concerning the `SearchBarWidet`: by not specifying any index there, InstantSearch will conclude that the Search bar should search in all index. If an index was specified, then the `SearchBarWidget` would only trigger a search in that particular widget. 

## Go further

Your application now displays your data from multiple indices, lets your users enter a query, displays search results as-they-type and lets users filter by refinements: you just built a full instant-search interface! Congratulations 🎉

This is only an introduction to what you can do with InstantSearch iOS: 
- Have a look at our [examples][examples] to see more complex examples of applications built with InstantSearch.
- You can also head to our [Widgets page][widgets] to see the other components that you could use.
- You can check how to customise further your widgets and view controllers with [ViewModels](viewmodels).

[algolia_sign_up]: https://www.algolia.com/users/sign_up
[widgets]: widgets.html
[examples]: examples.html
[widgets-hits]: widgets.html#hits
[widgets-searchbox]: widgets.html#searchbar
[widgets-refinementlist]: widgets.html#refinementlist
[widgets-stats]: widgets.html#stats
[viewmodels]: concepts.html#viewmodels