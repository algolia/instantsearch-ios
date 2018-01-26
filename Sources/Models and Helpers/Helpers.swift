//
//  Copyright (c) 2015 Algolia
//  http://www.algolia.com/
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import InstantSearchCore
import UIKit

private var highlightedBackgroundColorKey: Void?
private var isHighlightingInversedKey: Void?

/// Extension menthods for UILabel used to highlight hits
extension UILabel {
    
    /// The highlighted background color of the string that matches the search query in Algolia's index.
    /// + Note: This can only be used with the InstantSearch library.
    @objc public var highlightedBackgroundColor: UIColor? {
        get {
            return objc_getAssociatedObject(self, &highlightedBackgroundColorKey) as? UIColor
        }
        set(newValue) {
            objc_setAssociatedObject(self, &highlightedBackgroundColorKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    /// Whether or not the highlighted background color of the string that matches the search query is inverted or not.
    /// + Note: This can only be used with the InstantSearch library.
    @objc public var isHighlightingInversed: Bool {
        get {
            guard let isHighlightingInversed = objc_getAssociatedObject(self, &isHighlightingInversedKey) as? Bool else {
                return false
            }
            
            return isHighlightingInversed
        }
        set(newValue) {
            objc_setAssociatedObject(self, &isHighlightingInversedKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    /// The text to be highlighte. This should be the string that matches the search query in Algolia's index.
    /// + Note: This can only be used with the InstantSearch library.
    @objc public var highlightedText: String? {
        get {
            return attributedText?.string
        }
        set {
            guard let newValue = newValue, !newValue.isEmpty else { return }
            
            let text = isHighlightingInversed ? Highlighter(highlightAttrs: [:]).inverseHighlights(in: newValue) : newValue
            
            let textColor = highlightedTextColor ?? self.tintColor ?? UIColor.blue
            let backgroundColor = highlightedBackgroundColor ?? UIColor.clear
            
            attributedText = Highlighter(highlightAttrs: [NSAttributedStringKey.foregroundColor: textColor,
                                                          NSAttributedStringKey.backgroundColor: backgroundColor]).render(text: text)
        }
    }
}

func print(_ item: @autoclosure () -> Any, separator: String = " ", terminator: String = "\n") {
    #if DEBUG
        Swift.print(item(), separator:separator, terminator: terminator)
    #endif
}

internal struct WeakSet<T>: Sequence where T : AnyObject{
    
  private var _objects: NSHashTable<T>
  
  public init() {
    _objects = NSHashTable<T>.weakObjects()
  }
  
  public init(_ objects: [T]) {
    self.init()
    add(objects)
  }
  
  public var objects: [T] {
    return _objects.allObjects
  }
  
  public func contains(object: T) -> Bool {
    return _objects.contains(object)
  }
  
  public mutating func add(_ object: T) {
    _objects.add(object)
  }
  
  public mutating func add(_ objects: [T]) {
    objects.forEach({ self._objects.add($0)})
  }
  
  public mutating func remove(_ object: T) {
    _objects.remove(object)
  }
  
  public mutating func remove(_ objects: [T]) {
    objects.forEach({ self._objects.remove($0)})
  }
  
  public func makeIterator() -> AnyIterator<T> {
    let objects = self.objects
    var index = 0
    return AnyIterator {
      defer { index += 1 }
      return index < objects.count ? objects[index] : nil
    }
  }
}
