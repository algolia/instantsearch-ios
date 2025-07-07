# ChangeLog

## [7.27.0](https://github.com/algolia/instantsearch-ios/compare/7.26.4...7.27.0) (2025-07-01)

### Fix

- add `requestOptions` to `MultiSearcher` init (#341) ([51a0890](https://github.com/algolia/instantsearch-ios/commit/51a089052fa485519e1c15b68602b13d81190bcd))


## [7.26.4](https://github.com/algolia/instantsearch-ios/compare/7.26.3...7.26.4) (2025-02-19)

### Fix

- **sortby**: properly map indices names (#332) ([a4cdf26](https://github.com/algolia/instantsearch-ios/commit/a4cdf26))

### Refactor

- optimize page map iterator to avoid items copying (#329) ([d3eff80](https://github.com/algolia/instantsearch-ios/commit/d3eff80))



## [7.26.3](https://github.com/algolia/instantsearch-ios/compare/7.26.2...7.26.3) (2024-07-29)

### Fix

- conform pagemap extension to sequence protocol (#321) ([a921ecb](https://github.com/algolia/instantsearch-ios/commit/a921ecb))



## [7.26.2](https://github.com/algolia/instantsearch-ios/compare/7.26.1...7.26.2) (2024-06-04)

### Fix

- align versions with api client (#315) ([27105ae](https://github.com/algolia/instantsearch-ios/commit/27105ae))
- **insights**: control auto sending events w/ `isAutoSendingHitsViewEvents` (#314) ([8573411](https://github.com/algolia/instantsearch-ios/commit/8573411))



## [7.26.1](https://github.com/algolia/instantsearch-ios/compare/7.26.0...7.26.1) (2023-08-28)

### Misc
- SwiftUI query suggestions example (#294) ([47d296a](https://github.com/algolia/instantsearch-ios/commit/47d296a))

## [7.26.0](https://github.com/algolia/instantsearch-ios/compare/7.25.2...7.26.0) (2023-08-16)

### Feat

- **searchbox**: query debouncing (#297) ([0c3a7fd](https://github.com/algolia/instantsearch-ios/commit/0c3a7fd))



## [7.25.2](https://github.com/algolia/instantsearch-ios/compare/7.25.1...7.25.2) (2023-06-11)

### Fix

- **filters**: issue with textual value escaping (#293) ([a2a7b73](https://github.com/algolia/instantsearch-ios/commit/a2a7b73))
- Examples app (#288) ([cfd7b9b](https://github.com/algolia/instantsearch-ios/commit/cfd7b9b))



## [7.25.1](https://github.com/algolia/instantsearch-ios/compare/7.25.0...7.25.1) (2023-05-30)

### Misc

- fix(dynamic facets): recalculate selections on facets order change (#289) ([168505a](https://github.com/algolia/instantsearch-ios/commit/168505a))



## [7.25.0](https://github.com/algolia/instantsearch-ios/compare/7.24.0...7.25.0) (2023-05-05)

### Fix

- redundant search request sent by NumberRangeConnector (#283) ([7c68b57](https://github.com/algolia/instantsearch-ios/commit/7c68b57))

### Feat

- **HitsTracker**: add automatic object ids chunking (#284) ([5c1a04a](https://github.com/algolia/instantsearch-ios/commit/5c1a04a))
- **hits**: Inifinite Scroll components (#282) ([2b8eced](https://github.com/algolia/instantsearch-ios/commit/2b8eced))



## [7.24.0](https://github.com/algolia/instantsearch-ios/compare/7.23.0...7.24.0) (2023-05-02)

### Feat

- **insights**: automatic hits view events tracking (#276) ([501bb00](https://github.com/algolia/instantsearch-ios/commit/501bb00))



## [7.23.0](https://github.com/algolia/instantsearch-ios/compare/7.22.0...7.23.0) (2023-02-12)

### Feat

- **Insights**: add user-agent extension (#274) ([42b5d08](https://github.com/algolia/instantsearch-ios/commit/42b5d08))



## [7.22.0](https://github.com/algolia/instantsearch-ios/compare/7.21.2...7.22.0) (2023-01-30)

### Feat

- **dynamicFacetList**: add default selection & faceting parameters (#272) ([1c311b5](https://github.com/algolia/instantsearch-ios/commit/1c311b5))

### Fix

- **HitsObservableController**: empty queries conditional display not working (#267) ([d67b03a](https://github.com/algolia/instantsearch-ios/commit/d67b03a))
- send empty events packages if all non statisfying condition (#268) ([0dcd985](https://github.com/algolia/instantsearch-ios/commit/0dcd985))



## [7.21.2](https://github.com/algolia/instantsearch-ios/compare/7.21.1...7.21.2) (2022-11-02)

### Fix

- **multi-search**: crash in case of requests-results count mismatch (#261) ([47ae361](https://github.com/algolia/instantsearch-ios/commit/47ae361))



## [7.21.1](https://github.com/algolia/instantsearch-ios/compare/7.21.0...7.21.1) (2022-10-13)

### Fix

- **DynamicFacetListInteractor**: Updating `orderedFacets` of the `DynamicFacetListInteractor` ignores `disjunctiveFacets` (#258) ([abcc825](https://github.com/algolia/instantsearch-ios/commit/abcc825))
- **HitsInteractor**: Missing json decoder in convenience initalizer (#257) ([5981de8](https://github.com/algolia/instantsearch-ios/commit/5981de8))



## [7.21.0](https://github.com/algolia/instantsearch-ios/compare/7.20.1...7.21.0) (2022-09-29)

### Fix

- **Searcher**: make AbstractSearcher and IndexSearcher open (#255) ([f67cf46](https://github.com/algolia/instantsearch-ios/commit/f67cf46))

### Feat

- **HitsInteractor**: ability to set a custom json decoder to hits interactor (#254) ([91628d7](https://github.com/algolia/instantsearch-ios/commit/91628d7))



## [7.20.1](https://github.com/algolia/instantsearch-ios/compare/7.20.0...7.20.1) (2022-09-27)

### Fix

- **hierarchical**: Hierarchical facets clearing (#252) ([3ba16f7](https://github.com/algolia/instantsearch-ios/commit/3ba16f7))



## [7.20.0](https://github.com/algolia/instantsearch-ios/compare/7.19.1...7.20.0) (2022-08-31)

### Refactor

- **logging**: Logging logic (#248) ([25d5e3e](https://github.com/algolia/instantsearch-ios/commit/25d5e3e))



## [7.19.1](https://github.com/algolia/instantsearch-ios/compare/7.19.0...7.19.1) (2022-08-04)

### Fix

- **hierarchical**: deselect item (#236) ([804ca2b](https://github.com/algolia/instantsearch-ios/commit/804ca2b))



## [7.19.0](https://github.com/algolia/instantsearch-ios/compare/...7.19.0) (2022-07-18)

### Feat

- NumberObservableController implementation (#233) ([7c9cfa9](https://github.com/algolia/instantsearch-ios/commit/7c9cfa9))

### Fix

- SwiftUI infinite scrolling issue (#228) ([6f924e3](https://github.com/algolia/instantsearch-ios/commit/6f924e3))

### Chore

- Update GitHub actions (#229) ([712e190](https://github.com/algolia/instantsearch-ios/commit/712e190))
- Deprecate Boundable <-> Search Result Provider connection (#230) ([bbde414](https://github.com/algolia/instantsearch-ios/commit/bbde414))
- Deprecate Answers components (#231) ([35e6848](https://github.com/algolia/instantsearch-ios/commit/35e6848))
- Deprecate Places components (#232) ([180909a](https://github.com/algolia/instantsearch-ios/commit/180909a))



## [7.18.0](https://github.com/algolia/instantsearch-ios/compare/...7.18.0) (2022-06-21)

### Fix

- Carthage build issue (#224) ([e3384dc](https://github.com/algolia/instantsearch-ios/commit/e3384dc))



## [7.17.0](https://github.com/algolia/instantsearch-ios/compare/...7.17.0) (2022-05-22)

### Feat

- **CurrentFiltersObservableController**: add removal capability
- **StatsObservableController**: add empty constructor
- **SearchBar**: fix the appearance, make platform-agnostic
- **QueryInput**: rename to **SearchBox**
- **SelectableFilter**: rename to **FilterMap**

### Chore

- Migrate the demos from the separate [repository](https://github.com/algolia/instantsearch-ios-examples) (#217) ([a4fb97e](https://github.com/algolia/instantsearch-ios/commit/a4fb97e))
- Declare json files used in unit tests as library resources and update the tests accordingly


## [7.16.0](https://github.com/algolia/instantsearch-ios/compare/7.15.0...7.16.0) (2021-12-15)

### Feat

- Expose the pageCleanUpOffset parameter (#208) ([1341c42](https://github.com/algolia/instantsearch-ios/commit/1341c42))

### Chore

- Implement [telemetry data collection](https://www.algolia.com/doc/guides/building-search-ui/going-further/telemetry/ios/) (#210) [(7c83f8a)](https://github.com/algolia/instantsearch-ios/commit/7c83f8a)


## [7.15.0](https://github.com/algolia/instantsearch-ios/compare/7.14.0...7.15.0) (2021-11-05)

### Refactor

- Searchers refactoring (#184) ([9e85b7c](https://github.com/algolia/instantsearch-ios/commit/9e85b7c))



## [7.14.0](https://github.com/algolia/instantsearch-ios/compare/7.13.5...7.14.0) (2021-10-01)

### Refactor

- Separate the InstantSearchSwiftUI product (#193) ([a321c41](https://github.com/algolia/instantsearch-ios/commit/a321c41))



## [7.13.5](https://github.com/algolia/instantsearch-ios/compare/7.13.4...7.13.5) (2021-09-23)

### Fix

- tvOS and watchOS compiler issues (#197) ([9d470e8](https://github.com/algolia/instantsearch-ios/commit/9d470e8))



## [7.13.4](https://github.com/algolia/instantsearch-ios/compare/7.13.3...7.13.4) (2021-09-22)

### Fix

- Xcode 13 archive issues (#195) ([15687b0](https://github.com/algolia/instantsearch-ios/commit/15687b0))



## [7.13.3](https://github.com/algolia/instantsearch-ios/compare/7.13.2...7.13.3) (2021-09-08)

### Fix

- Xcode 13 compiler issues (#179) ([1665c7a](https://github.com/algolia/instantsearch-ios/commit/1665c7a))



## [7.13.2](https://github.com/algolia/instantsearch-ios/compare/7.13.1...7.13.2) (2021-08-30)

### Fix

- Compiler & archive issues (#189) ([4fcbbf8](https://github.com/algolia/instantsearch-ios/commit/4fcbbf8))



## [7.13.1](https://github.com/algolia/instantsearch-ios/compare/7.13.0...7.13.1) (2021-08-05)

### Fix

- remove objc leftovers causing the crash (#186) ([dd928a6](https://github.com/algolia/instantsearch-ios/commit/dd928a6))



## [7.13.0](https://github.com/algolia/instantsearch-ios/compare/7.12.1...7.13.0) (2021-08-03)

### Feat

- **SwiftUI**: Full-fledged SwiftUI support (#178) ([a189b0c](https://github.com/algolia/instantsearch-ios/commit/a189b0c))



## [7.12.1](https://github.com/algolia/instantsearch-ios/compare/7.12.0...7.12.1) (2021-07-22)

### Fix

- Bump API client dependencies (#181) ([046216d](https://github.com/algolia/instantsearch-ios/commit/046216d))



## [7.12.0](https://github.com/algolia/instantsearch-ios/compare/7.11.1...7.12.0) (2021-07-13)

### Feat

- Dynamic Faceting widget (#168) ([52508ca](https://github.com/algolia/instantsearch-ios/commit/52508ca))



## [7.11.1](https://github.com/algolia/instantsearch-ios/compare/7.11.0...7.11.1) (2021-05-27)

### Fix

- Add conditional imports for Combine & SwiftUI (#173) ([c9ab1d5](https://github.com/algolia/instantsearch-ios/commit/c9ab1d5))



## [7.11.0](https://github.com/algolia/instantsearch-ios/compare/7.10.0...7.11.0) (2021-04-30)

### Feat

- SwiftUI support (#167) ([2b027f2](https://github.com/algolia/instantsearch-ios/commit/2b027f2))



## [7.10.0](https://github.com/algolia/instantsearch-ios/compare/7.9.1...7.10.0) (2021-03-30)

### Feat

- FacetListInteractor - MultiIndexSearcher connection (#169) ([ab7af08](https://github.com/algolia/instantsearch-ios/commit/ab7af08))



## [7.9.1](https://github.com/algolia/instantsearch-ios/compare/7.9.0...7.9.1) (2021-03-09)

### Fix

- wrap ios availability for advanced connectors initializers (#165) ([c768bd3](https://github.com/algolia/instantsearch-ios/commit/c768bd3))



## [7.9.0](https://github.com/algolia/instantsearch-ios/compare/7.8.0...7.9.0) (2021-03-04)

### Misc

- feat(relevant sort):  Relevant sort widget (#162) ([d77bb60](https://github.com/algolia/instantsearch-ios/commit/d77bb60))



## [7.8.0](https://github.com/algolia/instantsearch-ios/compare/7.7.0...7.8.0) (2021-01-29)

### Feat

- AnswersSearcher & connections (#159) ([5daebc4](https://github.com/algolia/instantsearch-ios/commit/5daebc4))



## [7.7.0](https://github.com/algolia/instantsearch-ios/compare/7.6.2...7.7.0) (2021-01-07)

### Feat

- Manual setting of disjunctive facets (#150) ([99d6a9d](https://github.com/algolia/instantsearch-ios/commit/99d6a9d))



## [7.6.2](https://github.com/algolia/instantsearch-ios/compare/7.6.1...7.6.2) (2020-12-28)

### Fix

- remove legacy Insights dependency from the podspec (#155) ([0b127ed](https://github.com/algolia/instantsearch-ios/commit/0b127ed))



## [7.6.1](https://github.com/algolia/instantsearch-ios/compare/7.6.0...7.6.1) (2020-12-21)

### Fix

- broken geolocated conformance (#152) ([d2823eb](https://github.com/algolia/instantsearch-ios/commit/d2823eb))



## [7.6.0](https://github.com/algolia/instantsearch-ios/compare/7.5.0...7.6.0) (2020-11-16)

### Feat

- Implement NumericRatingRangeController (#147) ([a372b84](https://github.com/algolia/instantsearch-ios/commit/a372b84))
- Implement RatingControl & NumericRatingController (#146) ([8b50dec](https://github.com/algolia/instantsearch-ios/commit/8b50dec))



## [7.5.0](https://github.com/algolia/instantsearch-ios/compare/7.4.0...7.5.0) (2020-11-04)

### Feat

- Improve API convenience (#141) ([789e092](https://github.com/algolia/instantsearch-ios/commit/789e092))
- Connection between Numeric filter and Searcher to fetch numeric value bounds (#143) ([4f6509b](https://github.com/algolia/instantsearch-ios/commit/4f6509b))

### Refactor

- Suppress generic requirements in `LoadingConnector` and `QueryInputConnector` (#142) ([85f9f69](https://github.com/algolia/instantsearch-ios/commit/85f9f69))



## [7.4.0](https://github.com/algolia/instantsearch-ios/compare/7.3.0...7.4.0) (2020-10-27)

### Feat

- Integration of InstantSearch Insights library into the main InstantSearch package (#137) ([65da836](https://github.com/algolia/instantsearch-ios/commit/65da836))


