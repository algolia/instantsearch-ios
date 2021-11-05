//
//  MultiSearchService.swift
//  
//
//  Created by Vladislav Fitc on 08/09/2021.
//

import Foundation

public protocol MultiSearchService: SearchService where Request: MultiRequest, Result: MultiResult {}
