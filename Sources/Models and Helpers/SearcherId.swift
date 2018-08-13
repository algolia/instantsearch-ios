//
//  IndexId.swift
//  AlgoliaSearch-Client-Swift
//
//  Created by Guy Daher on 14/11/2017.
//

import Foundation

@objcMembers public class SearcherId: NSObject {
    
    /// The name of the index.
    public var index: String
    
    /// A unique id of your choice.
    ///
    /// + NOTE: Only useful to fill when different widgets are targeting the same index but with different configurations.
    public var variant: String
    
    public convenience init(index: String) {
        self.init(index: index, variant: "")
    }
    
    public init(index: String, variant: String) {
        self.index = index
        self.variant = variant
    }
    
    override public var hash: Int {
        return "\(index)\(variant)".hashValue
    }
    
    override public func isEqual(_ object: Any?) -> Bool {
        guard let rhs = object as? SearcherId else { return false }
        
        return (index == rhs.index) && (variant == rhs.variant)
    }
}
