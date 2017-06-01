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

Go to your `AppDelegate.swift` file and add the following under the `didFinishLaunchingWithOptions:` method:

```swift
InstantSearch.reference.configure(appID: "latency", apiKey: "1f6fd3a6fb973cb08419fe7d288fa4db", index: "bestbuy_promo")
InstantSearch.reference.params.attributesToRetrieve = ["name", "salePrice"]
InstantSearch.reference.params.attributesToHighlight = ["name"]
```

This will initialize InstantSearch with the credentials proposed at the beginning. You can also chose to replace them with the credentials of your own app.

To understand the above, we are using the singleton `InstantSearch.reference` to configure InstantSearch with our Algolia credentials. `InstantSearch.reference` will be used throughout our app to easily deal with InstantSearch. Note that you can also create your own instance of `InstantSearch` and pass it around your Controllers, but we won't do that in this guide.

Next, we added the attributes that we want to retrieve and highlight. Note that this can be specified in the Algolia dashboard by going to Indices -> Display tab. If you added the configuration there, then you do not need to specify the `attributesToRetrieve` and `attributesToHighlight` as shown above.

## Search your data: the SearchBar

Any search experience requires a SearchBar, and this is what we're going to start with. We will also add a `Stats` widget to show how the number of results change when you type a query in your SearchBar. 

### Programatically

Go to your `ViewController.swift` file and then inside your `viewDidLoad` method, add the following: 

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

Run your app with `Cmd` + `r`, and then search in the SearchBar on the screen. You should see that the results are changing on each key stroke. Nice stuff with so little code!

### Storyboard

### Recap

Fantastic! You just used your very first widgets from InstantSearch.
InstantSearch will automatically recognize your SearchBar as a source of search queries.

In this part, you've learned:

- How to create a SearchBar Widget
- How to create a StatsLabel Widget
- How to add widgets to InstantSearch

## Display your data: Hits and helpers

InstantSearch iOS is based on a system of [widgets][widgets] that communicate when a user interacts with your app. The first widget we'll add is **[Hits][widgets-hits]**, which will display your search results.


- To keep this guide simple, we'll replace the main activity's layout by a vertical `LinearLayout`:
```xml
<?xml version="1.0" encoding="utf-8"?>
<LinearLayout
    iOS:id="@+id/activity_main"
    xmlns:iOS="http://schemas.iOS.com/apk/res/iOS"
    iOS:layout_width="match_parent"
    iOS:layout_height="match_parent"
    iOS:orientation="vertical">
</LinearLayout>
```

<div id="itemlayout" />

- You can then add the `Hits` widget to your layout:
```xml
<com.algolia.instantsearch.ui.views.Hits
        iOS:layout_width="match_parent"
        iOS:layout_height="wrap_content"
        algolia:itemLayout="@layout/hits_item"/>
```

The `itemLayout` attribute references a layout that will be used to display each item of the results. This layout will contain a `View` for each attribute of our data that we want to display.
- Let's create a new layout called **`hits_item.xml`**:
```xml
<?xml version="1.0" encoding="utf-8"?>
<LinearLayout xmlns:iOS="http://schemas.iOS.com/apk/res/iOS"
              iOS:orientation="horizontal"
              iOS:layout_width="match_parent"
              iOS:layout_height="match_parent">
    <ImageView
        iOS:layout_width="wrap_content"
        iOS:layout_height="wrap_content"
        iOS:id="@+id/product_image"/>
    <TextView
        iOS:layout_width="wrap_content"
        iOS:layout_height="wrap_content"
        iOS:id="@+id/product_name"/>
    <TextView
        iOS:layout_width="wrap_content"
        iOS:layout_height="wrap_content"
        iOS:id="@+id/product_price"/>
</LinearLayout>
```

- InstantSearch iOS will automatically bind your records to these Views using the [Data Binding Library][dbl].
First, enable it in your app's `build.gradle`:
```groovy
iOS {
    dataBinding.enabled true
    //...
}
```
- To use data binding in your layout, wrap it in a **`<layout>`** root tag.
You can then specify which View will hold each record's attribute:
add **`algolia:attribute='@{"foo"}'`** on a View to bind it to the `foo` attribute of your data:
```xml
<?xml version="1.0" encoding="utf-8"?>
<layout xmlns:algolia="http://schemas.iOS.com/apk/res-auto">
    <LinearLayout xmlns:iOS="http://schemas.iOS.com/apk/res/iOS"
                  iOS:layout_width="match_parent"
                  iOS:layout_height="match_parent"
                  iOS:orientation="horizontal">

        <ImageView
            iOS:id="@+id/product_image"
            iOS:layout_width="wrap_content"
            iOS:layout_height="wrap_content"
            algolia:attribute='@{"image"}'/>

        <TextView
            iOS:id="@+id/product_name"
            iOS:layout_width="wrap_content"
            iOS:layout_height="wrap_content"
            algolia:attribute='@{"name"}'/>

        <TextView
            iOS:id="@+id/product_price"
            iOS:layout_width="wrap_content"
            iOS:layout_height="wrap_content"
            algolia:attribute='@{"price"}'/>
    </LinearLayout>
</layout>
```
*Beware of the data binding attributes' syntax: **@'{"string"}'**.*

You have now a main activity layout containing your `Hits` widget, and a data-binding layout ready to display your search results. You just miss a search query to display its results!
As your application has no input for now, we will trigger the search programmatically.

- In your `MainActivity`, create a [`Searcher`][searcher] with your credentials:
```java
Searcher searcher = new Searcher(ALGOLIA_APP_ID, ALGOLIA_SEARCH_API_KEY, ALGOLIA_INDEX_NAME);
```

- Instantiate an [`InstantSearchHelper`][instantsearchhelper] to link your `Searcher` to your Activity:
```java
InstantSearchHelper helper = new InstantSearchHelper(this, searcher);
```

- Now your Activity is connected to Algolia through the Searcher, you can trigger a search using [`InstantSearchHelper#search(String)`][doc-instantsearch-search]:
```java
helper.search(); // Search with empty query
```

Your activity should now look like this:

```java
public class MainActivity extends AppCompatActivity {
    private static final String ALGOLIA_APP_ID = "latency";
    private static final String ALGOLIA_SEARCH_API_KEY = "3d9875e51fbd20c7754e65422f7ce5e1";
    private static final String ALGOLIA_INDEX_NAME = "bestbuy";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        Searcher searcher = new Searcher(ALGOLIA_APP_ID, ALGOLIA_SEARCH_API_KEY, ALGOLIA_INDEX_NAME);
        InstantSearchHelper helper = new InstantSearchHelper(this, searcher);
        helper.search();
    }
}
```

----

<img src="assets/img/mvp/step1.png" class="img-object" align="right"/>

**Build and run your application: you now have an InstantSearch iOS app displaying your data!**

<p class="cb">In this part you've learned:</p>

- How to build your interface with Widgets by adding the `Hits` widget
- How to create a data-binding `<layout>` for displaying search results
- How to initialize Algolia with your credentials
- How to trigger a search programmatically


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
