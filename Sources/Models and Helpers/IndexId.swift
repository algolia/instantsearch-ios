//
//  IndexId.swift
//  AlgoliaSearch-Client-Swift
//
//  Created by Guy Daher on 14/11/2017.
//

import Foundation

@objc public class IndexId: NSObject  {
    var name: String
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
        guard let rhs = object as? IndexId else { return false }
        
        return (name == rhs.name) && (id == rhs.id)
    }
}
