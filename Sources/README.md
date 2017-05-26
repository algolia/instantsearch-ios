# InstantSearch iOS

InstantSearch iOS is a library of widgets and helpers for building native, component-driven UIs with Algolia.
It is built on top of Algolia's Swift API Client to provide you a high-level solution to quickly build various search interfaces

## Widgets

The core part of InstantSearch iOS are the widgets, which are search-aware components that are binded to search events coming from Algolia.

Widgets binds `UIKit UIViews`, whether it is an advanced `UICollectionView`, or a simple `UISlider`.
They are also customisable by exposing `IBInspectable` parameters that can be set right through Interface Builder.

The nice thing about InstantSearch iOS is that you don't have to rewrite your existing `UIViews` to start using the library.
In fact, the architecture of the library is mostly protocol oriented, making it extendible and compatible with your existing UI.
It follows Plugin Architecture conventions by providing most of the business logic mostly through protocols, and sometimes through base `UIViewController` classes.

In that way, it is also very easy to create your own search-aware custom widgets. All it takes is implementing one or more protocols depending on the purpose of the widget, and then writing the business logic using the provided properties and methods coming from the protocols.
