//
//  Requestable.swift
//  Garage
//
//  Created by Davit on 15.05.24.
//

import Foundation

public protocol Requestable {
    var path: String { get }
    var queryItems: [URLQueryItem]? { get }
}

public extension Requestable {
    var queryItems: [URLQueryItem]? {
        return nil
    }
    
    func makeURLRequest(from configuration: NetworkConfiguration) -> URLRequest? {
        guard let url = makeURL(host: configuration.baseURL) else { return nil }
        return URLRequest(url: url)
    }
    
    func makeURL(host: String) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.path = "/" + path
        components.host = host
        components.queryItems = queryItems
        return components.url
    }
}
