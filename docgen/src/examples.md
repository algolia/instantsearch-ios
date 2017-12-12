---
title: Examples
layout: examples.pug
name: examples
category: main
withHeadings: true
navWeight: 0
editable: true
githubSource: docgen/src/examples.md
---

We made a demo application to give you an idea of what you can build with InstantSearch iOS:

## E-commerce application
<img src="assets/img/ecommerce.gif" class="img-object" align="right"/>

This example imitates a product search interface like well-known e-commerce applications.

- Search in the **product's name**, **type**, and **category**
- Filter with RefinementList by **type** or **category**
- Filter with Numeric filters by **price** or **rating**
- Custom views using `AlgoliaWidget` for filtering by **price** and **rating**.

<a href="https://github.com/algolia/instantsearch-swift-examples/tree/master/ecommerce%20Ikea" class="btn btn-static-primary" target="_blank">View source code on GitHub <i class="icon icon-arrow-right"></i></a>

<br />
<br />
<br />
<br />
<br />
<br />
<br />

## Tourism application
<img src="assets/img/icebnb.gif" align="right" width="300"/>

Example of a bed and breakfast search interface.

- Search a place by **your location** around you
- Filter with Numberic filters by **radius**
- Filter with RefinementList by **room_type**
- Filter with Numeric filters by **price**
- Custom views using `AlgoliaWidget` for filtering by **price** and **room_type**
- Custom widgets for linking the search results with the `MKMapView`

<a href="https://github.com/algolia/instantsearch-swift-examples/tree/master/Icebnb" class="btn btn-static-primary" target="_blank">View source code on GitHub <i class="icon icon-arrow-right"></i></a>

<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />


## Query Suggestions
<img src="assets/img/suggestion.gif" align="right" width="300"/>

Example of a query suggestion search interface.

- Query suggestions appear when clicking on the search bar
- When clicking a query suggestion, the search bar is filled with that suggestion and results are refreshed
- Showing how you can use the ViewModels for customization of your widgets

<a href="https://github.com/algolia/instantsearch-ios-examples/tree/master/Query%20Suggestions" class="btn btn-static-primary" target="_blank">View source code on GitHub <i class="icon icon-arrow-right"></i></a>

<br />
<br />
<br />
<br />
<br />

## Movies Demo
<img src="assets/img/Movies.gif" align="right" width="300"/>

Example of a multi-index search interface.

- Multi-Index table showcasing results from different indices (movies and actors)
- A load more button taking you to an infinite scrolling list
- Keep the state of the search when moving to the load more screen
- Uses the new iOS 11 SearchBar in NavigationBar.

<a href="https://github.com/algolia/instantsearch-ios-examples/tree/master/Movies" class="btn btn-static-primary" target="_blank">View source code on GitHub <i class="icon icon-arrow-right"></i></a>