//
//  Copyright (c) 2016 Algolia
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

import Foundation
import InstantSearchCore

@objc internal enum TransformRefinementList: Int {
    case countAsc
    case countDesc
    case nameAsc
    case nameDsc
    
    public init(named transformName: String) {
        switch transformName.lowercased() {
        case "count:asc": self = .countAsc
        case "count:desc": self = .countDesc
        case "name:asc": self = .nameAsc
        case "name:desc": self = .nameDsc
        default: self = .countDesc
        }
    }
}

extension RefinementMenuViewModel {
    @objc internal func getRefinementList(params: SearchParameters,
                                          facetCounts: [String: Int],
                                          andFacetName facetName: String,
                                          transformRefinementList: TransformRefinementList,
                                          areRefinedValuesFirst: Bool) -> [FacetValue] {
        
        let allRefinements = params.buildFacetRefinements()
        let refinementsForFacetName = allRefinements[facetName]
        
        let facetList = FacetValue.listFrom(facetCounts: facetCounts, refinements: refinementsForFacetName)
        
        let sortedFacetList = facetList.sorted { (lhs, rhs) in
            
            let lhsChecked = params.hasFacetRefinement(name: facetName, value: lhs.value)
            let rhsChecked = params.hasFacetRefinement(name: facetName, value: rhs.value)
            
            if areRefinedValuesFirst && lhsChecked != rhsChecked { // Refined wins
                return lhsChecked
            }
            
            let leftCount = lhs.count
            let rightCount = rhs.count
            let leftValueLowercased = lhs.value.lowercased()
            let rightValueLowercased = rhs.value.lowercased()
            
            switch transformRefinementList {
            case .countDesc:
                if leftCount != rightCount { // Biggest Count wins
                    return leftCount > rightCount
                } else {
                    return leftValueLowercased < rightValueLowercased // Name ascending wins by default
                }
                
            case .countAsc:
                if leftCount != rightCount { // Smallest Count wins
                    return leftCount < rightCount
                } else {
                    return leftValueLowercased < rightValueLowercased // Name ascending wins by default
                }
                
            case .nameAsc:
                if leftValueLowercased != rightValueLowercased {
                    return leftValueLowercased < rightValueLowercased // Name ascending
                } else {
                    return leftCount > rightCount // Biggest Count wins by default
                }
                
            case .nameDsc:
                if leftValueLowercased != rightValueLowercased {
                    return leftValueLowercased > rightValueLowercased // Name descending
                } else {
                    return leftCount > rightCount // Biggest Count wins by default
                }
            }
        }
        
        return sortedFacetList
    }
}
