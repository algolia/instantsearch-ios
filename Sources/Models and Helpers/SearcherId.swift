//
//  IndexId.swift
//  AlgoliaSearch-Client-Swift
//
//  Created by Guy Daher on 14/11/2017.
//

import Foundation

@objc public class SearcherId: NSObject {
    
    /// The name of the index.
    var name: String
    
    /// A unique id of your choice.
    ///
    /// + NOTE: Only useful to fill when different widgets are targeting the same index but with different configurations.
    var id: String
    
    public convenience init(name: String) {
        self.init(name: name, id: "")
    }
    
    public init(name: String, id: String) {
        self.name = name
        self.id = id
    }
    
    override public var hashValue: Int {
        return "\(name)\(id)".hashValue
    }
    
    override public func isEqual(_ object: Any?) -> Bool {
        guard let rhs = object as? SearcherId else { return false }
        
        return (name == rhs.name) && (id == rhs.id)
    }
}
