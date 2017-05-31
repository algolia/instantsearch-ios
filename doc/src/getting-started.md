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

## Create a new Project and add InstantSearch iOS
In Xcode, create a new Project:
- On the Template screen, select **Single View Application** and click next
- Specify your Product name, select Swift as the language, and iPhone as the Device. Then create.

We will use CocoaPods for adding the dependency to `InstantSearch`.

- On your terminal, go to the root of your project then type `pod init`. A PodFile will be created for you.
- Add pod 'AlgoliaSearch-InstantSearch-Swift', '~> 0.1.0' to your Podfile below your target.
- On your terminal, type `pod install`
- Open your .xcworkspace project created at the root of your project


## Build the User Interface and display your data: Hits and helpers

InstantSearch iOS is based on a system of [widgets][widgets] that communicate when an user interacts with your app. The first widget we'll add is **[Hits][widgets-hits]**, which will display your search results.


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

## Search your data: the SearchBox

Your application displays search results, but for now the user cannot input anything.
This will be the role of another Widget: the **[`SearchBox`][widgets-searchbox]**.


<br />
<img src="assets/img/widget_SearchBox.png" class="img-object" align="right"/>
<br />
<br />
<br />



- Add a `SearchBox` to your `main_activity.xml`:
```xml
<com.algolia.instantsearch.ui.views.SearchBox
        iOS:layout_width="match_parent"
        iOS:layout_height="wrap_content"/>
```

InstantSearch will automatically recognize your SearchBox as a source of search queries.
Restart your app and tap a few characters: you now have a fully functional search interface!

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
