//
//  APIEnvironment.swift
//  PhotoVIewMVVM
//
//  Created by Julio Reyes on 6/18/19.
//  Copyright © 2019 Julio Reyes. All rights reserved.
//

import Foundation

enum Environment{
    case dev
    case test
    case prod
    
    func baseURL() -> String {
        return "\(urlAppProtocol())://\(urlPhotoDomain())"
    }
    
    func urlAppProtocol() -> String{
        switch self {
        case .prod:
            return "https"
        default:
            return "http"
        }
    }
    
    func urlPhotoDomain() -> String{
        switch self {
        case .dev, .test, .prod:
            return "jsonplaceholder.typicode.com"
        }
    }
    
    func urlRoute() -> String{
        return "3"
    }
}

// In an actual application, this would the proper setup for my API environments
// But for the sake of expediency, the environment will run as if it were on Production
/*
 #if DEBUG
 let enviroment: Environment = .dev
 #else
 let enviroment: Environment = .prod
 #endif
 */

let enviroment: Environment = .prod
let baseURL = enviroment.baseURL()

struct Path {
    var photoSearch: String {
        return "\(baseURL)/photos"
    }
}
