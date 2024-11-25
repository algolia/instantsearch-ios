import Insights

extension EventsItems {
  var timestamp: Int64? {
    switch self {
    case let .addedToCartObjectIDsAfterSearch(value):
      return value.timestamp
    case let .purchasedObjectIDsAfterSearch(value):
      return value.timestamp
    case let .clickedObjectIDsAfterSearch(value):
      return value.timestamp
    case let .purchasedObjectIDs(value):
      return value.timestamp
    case let .addedToCartObjectIDs(value):
      return value.timestamp
    case let .convertedObjectIDsAfterSearch(value):
      return value.timestamp
    case let .clickedObjectIDs(value):
      return value.timestamp
    case let .convertedObjectIDs(value):
      return value.timestamp
    case let .clickedFilters(value):
      return value.timestamp
    case let .convertedFilters(value):
      return value.timestamp
    case let .viewedObjectIDs(value):
      return value.timestamp
    case let .viewedFilters(value):
      return value.timestamp
    }
  }
}
