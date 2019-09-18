//
//  APIClientService.swift
//  PhotoVIewMVVM
//
//  Created by Julio Reyes on 6/18/19.
//  Copyright © 2019 Julio Reyes. All rights reserved.
//

import Foundation

// With the introduction to Swift 4, we are now given more customization to parsing JSON. I decided to use the JSONDecoder for it makes it easier for me to define the properties that the JSON file gives to it. More customization and removes the clutter from the data structures' composition of the NSCoding protocol and traditional JSON parsing (If you parsed JSON between 2012-2015 in Obj-C, you know). Also, making the data structure Codable would allow me to save the data off-line with the NSKeyedArchiver.
fileprivate func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

class APIClientService: NSObject {
    
    //MARK: Singleton
    static let defaultSessionConfiguration = URLSessionConfiguration.default
    static let defaultSession = URLSession(configuration: defaultSessionConfiguration)
        
    // MARK: Network Calls
    func downloadSearchResultsForPhotos(complete: @escaping PhotoDataRetrievalComplete,
                                        failure: @escaping (Error?) -> ()) throws -> Void {
        let urlPathString = Path().photoSearch
        guard URL(string: urlPathString) != nil else {
            print( "Something went wrong. No URL processed. On guard.")
            throw NSError(domain: NSURLErrorDomain, code: NSURLErrorBadURL, userInfo: nil)
        }

        var searchRequest = URLRequest(url: URL(string: urlPathString)!,
                                       cachePolicy: .useProtocolCachePolicy,
                                       timeoutInterval: 10.0)
        
        searchRequest.httpMethod = "GET"
        
        print( "\(urlPathString)")

        let task = APIClientService.defaultSession.dataTask(with: searchRequest, completionHandler: { (data: Data?,
            response: URLResponse?, error: Error?) in
            guard let _ = response as? HTTPURLResponse, let data = data else {
                print("API response error")
                failure(error?.localizedDescription as? Error)
                return
            }
            
            // Parse the data
            let photoSearch = try! newJSONDecoder().decode(PhotoSearch.self, from: data)
            complete (photoSearch, response)
            
        })
        task.resume()
    }
}

