//
//  LocalStorage.swift
//  Insights
//
//  Created by Robert Mogos on 01/06/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import Foundation

class LocalStorage<V: Codable> {
    static func filePath(for index: String) -> String? {
        let filename = "algolia-\(index)"
        let manager = FileManager.default
        
        #if os(iOS)
        let url = manager.urls(for: .libraryDirectory, in: .userDomainMask).last
        #else
        let url = manager.urls(for: .cachesDirectory, in: .userDomainMask).last
        #endif // os(iOS)
        
        guard let urlUnwrapped = url?.appendingPathComponent(filename).path else {
            return nil
        }
        return urlUnwrapped
    }
    
    @discardableResult static func deleteFile(atPath path: String) -> Bool {
        let exists = FileManager.default.fileExists(atPath: path)
        if let url = URL(string: path), exists {
            do {
                try FileManager.default.removeItem(at: url)
            } catch let error {
                debugPrint(error.localizedDescription)
                return false
            }
        }
        return exists
    }
    
    @discardableResult static func serialize(_ objects: V, file: String) -> Bool {
        do {
            let data = try PropertyListEncoder().encode(objects)
            return NSKeyedArchiver.archiveRootObject(data, toFile: file)
        } catch {
            return false
        }
    }
    
    static func deserialize(_ file: String) -> V? {
        guard let data = NSKeyedUnarchiver.unarchiveObject(withFile: file) as? Data else {
            return nil
        }
        do {
            let object = try PropertyListDecoder().decode(V.self, from: data)
            return object
        } catch {
            return nil
        }
    }
}
