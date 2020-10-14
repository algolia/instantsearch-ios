//
//  Syncable.swift
//  Insights
//
//  Created by Vladislav Fitc on 05/11/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import Foundation

protocol Syncable {
    func sync() -> Resource<Bool, WebserviceError>
}
