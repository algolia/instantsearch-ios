//
//  WebService.swift
//  Insights
//

//  Copyright © 2018 Algolia. All rights reserved.
//

import Foundation

class WebService {
    let urlSession: URLSession
    let logger: Logger
    
    init(sessionConfig: URLSessionConfiguration, logger: Logger) {
        self.logger = logger
        urlSession = URLSession(configuration: sessionConfig)
    }
    
    public func makeRequest<A, E>(for resource: Resource<A, E>) -> URLRequest {
        var request = URLRequest(resource: resource)
        request.addValue(WebService.computeUserAgent(), forHTTPHeaderField: "User-Agent")
        return request
    }
    
    public func load<A, E>(resource: Resource<A, E>, completion: @escaping (Result<A?, Error>) -> Void) {
        let request = makeRequest(for: resource)
        urlSession.dataTask(with: request, completionHandler: { (data, response, error) in
            if let error  = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            guard let response = response as? HTTPURLResponse else {
                DispatchQueue.main.async {(
                    completion(.failure(WebserviceError(code: -1, message: "Unknown response type")))
                    )}
                return
            }
            if response.statusCode == 200 || response.statusCode == 201 {
                if let parsed: A = data.flatMap(resource.parse) {
                    DispatchQueue.main.async {
                        completion(.success(parsed))
                    }
                } else {
                    if resource.allowEmptyResponse {
                        DispatchQueue.main.async { completion(.success(nil)) }
                    } else {
                        DispatchQueue.main.async { completion(.failure(WebserviceError(code: -1, message: "Fail to parse"))) }
                    }
                }
            } else {
                let parsedApiError = data.flatMap({resource.errorParse(response.statusCode, $0)}) as? WebserviceError
                let error = parsedApiError ?? WebserviceError(code: -1, message: "Unknown response type")
                DispatchQueue.main.async { completion(.failure(error)) }
            }
        }).resume()
    }
}

// MARK: UserAgent
typealias LibraryVersion = (name: String, version: String)
extension WebService {
  
  /// The operating system's name.
  ///
  /// - returns: The operating system's name, or nil if it could not be determined.
  ///
  internal static func osName() -> String? {
    #if os(iOS)
    return "iOS"
    #elseif os(OSX)
    return "macOS"
    #elseif os(tvOS)
    return "tvOS"
    #elseif os(watchOS)
    return "watchOS"
    #else
    return nil
    #endif
  }
  // Computing the User Agent. Expected output: insights-ios (2.1.0); iOS (12.1.0)
  internal static func computeUserAgent() -> String {
    var userAgents: [LibraryVersion] = []
    
    let packageVersion = Bundle(for: WebService.self).infoDictionary!["CFBundleShortVersionString"] as! String
    userAgents.append(LibraryVersion(name: "insights-ios", version: packageVersion))
    if let osInfo = osInfo() {
      userAgents.append(osInfo)
    }
    return userAgents.map({ "\($0.name) (\($0.version))" }).joined(separator: "; ")
  }
  
  internal static func osInfo() -> LibraryVersion? {
    if #available(iOS 8.0, OSX 10.0, tvOS 9.0, *) {
      let osVersion = ProcessInfo.processInfo.operatingSystemVersion
      let osVersionString = "\(osVersion.majorVersion).\(osVersion.minorVersion).\(osVersion.patchVersion)"
      if let osName = WebService.osName() {
        return LibraryVersion(name: "\(osName)", version: osVersionString)
      }
    }
    return nil
  }
}

public protocol APIError: Error {
    var code: Int { get }
    var message: String { get }
    var localizedDescription: String { get }
}

public struct WebserviceError: APIError {
    public let code: Int
    public let message: String
    
    public var localizedDescription: String {
        return "\(message) (Code: \(code))"
    }
}
