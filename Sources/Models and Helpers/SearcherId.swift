//
//  IndexId.swift
//  AlgoliaSearch-Client-Swift
//
//  Created by Guy Daher on 14/11/2017.
//

import Foundation

@objc public class SearcherId: NSObject {
    
    /// The name of the index.
    var indexName: String
    
    /// A unique id of your choice.
    ///
    /// + NOTE: Only useful to fill when different widgets are targeting the same index but with different configurations.
    var id: String
    
    public convenience init(indexName: String) {
        self.init(indexName: indexName, id: "")
    }
    
    public init(indexName: String, id: String) {
        self.indexName = indexName
        self.id = id
    }
    
    override public var hashValue: Int {
        return "\(indexName)\(id)".hashValue
    }
    
    override public func isEqual(_ object: Any?) -> Bool {
        guard let rhs = object as? SearcherId else { return false }
        
        return (indexName == rhs.indexName) && (id == rhs.id)
    }
}
