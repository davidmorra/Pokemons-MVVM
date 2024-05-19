//
//  File.swift
//  
//
//  Created by Davit on 19.05.24.
//

import Foundation

public protocol NetworkConfiguration {
    var baseURL: String { get }
}

public struct NetworkConfigurationImpl: NetworkConfiguration {
    public var baseURL: String
    
    public init(baseURL: String) {
        self.baseURL = baseURL
    }
}

public extension NetworkConfigurationImpl {
    static var `default` = NetworkConfigurationImpl(baseURL: "pokeapi.co")
}
