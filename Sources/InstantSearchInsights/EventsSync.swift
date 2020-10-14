//
//  EventsSync.swift
//  Insights
//

//  Copyright © 2018 Algolia. All rights reserved.
//

import Foundation

extension WebService {
    
    public func sync(_ item: Syncable, completionHandler: @escaping (Error?) -> Void) {
        let resource = item.sync()
        load(resource: resource) { [weak self] result in
            let resultDescription: String
            switch result {
            case .success:
                resultDescription = "Sync succeded for \(item)"
                completionHandler(nil)
                
            case .failure(let err):
                resultDescription = (err as? WebserviceError)?.localizedDescription ?? err.localizedDescription
                completionHandler(err)
            }
            self?.logger.debug(message: resultDescription)
        }
    }
    
}
