//
//  File.swift
//  
//
//  Created by Davit on 15.05.24.
//

import Foundation

public struct RequestPage {
    public let offset: Int
    public let limit: Int
    
    public init(offset: Int, limit: Int = 20) {
        self.offset = offset
        self.limit = limit
    }
}

public enum PokemonAPI: Requestable {
    case id(_ id: Int)
    case page(_ page: RequestPage)
    
    public var path: String {
        switch self {
        case let .id(id):
            return "api/v2/pokemon/\(id)"
            
        case .page:
            return "api/v2/pokemon"
            
        }
    }
    
    public var queryItems: [URLQueryItem]? {
        switch self {
        case let .page(request):
            return [
                .init(name: "limit", value: "\(request.limit)"),
                .init(name: "offset", value: "\(request.offset)")
            ]
        case .id:
            return nil
        }
    }

}
