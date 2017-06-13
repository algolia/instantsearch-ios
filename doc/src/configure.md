There are two ways you can configure and initialize InstantSearch in iOS.

## Singleton

You can use the singleton shared reference of InstantSearch throughout your app. For that, you can simply use the publicly available `InstantSearch.shared`.

## Instance 

Another way to deal with InstantSearch is to just instantiate an `InstantSearch` instance with one of its constructors. Note that in this case, you will have to take the responsibility of passing that reference between different screens.