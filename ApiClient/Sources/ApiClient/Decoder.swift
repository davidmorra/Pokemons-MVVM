//
//  File.swift
//  
//
//  Created by Davit on 19.05.24.
//

import Combine
import Foundation

public protocol ResponseDecoding {
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable
}

public class ResponseDecoder: ResponseDecoding {
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromAnyCase
        return decoder
    }()
    
    public init() {}
    
    public func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable {
        return try decoder.decode(T.self, from: data)
    }
}

/// for Data types, e.g. Image fetch
public class DataResponseDecoder: ResponseDecoding {
    enum CodingKeys: String, CodingKey {
        case `default` = ""
    }
    
    public init() { }

    public func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable {
        if T.self is Data.Type, let data = data as? T {
            return data
        } else {
            let context = DecodingError.Context(codingPath: [CodingKeys.default], debugDescription: "Data type is expected")
            throw DecodingError.typeMismatch(T.self, context)
        }
    }
}
