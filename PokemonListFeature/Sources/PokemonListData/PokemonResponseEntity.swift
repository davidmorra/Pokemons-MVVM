//
//  File.swift
//  
//
//  Created by Davit on 16.05.24.
//

import Foundation
import PokemonListDomain

public struct PokemonAPIResponse: Decodable {
    public let count: Int
    public let next: String?
    public let previous: String?
    public let results: [NamedAPIResource]
    
    public init(count: Int, next: String?, previous: String?, results: [NamedAPIResource]) {
        self.count = count
        self.next = next
        self.previous = previous
        self.results = results
    }
}

public extension PokemonAPIResponse {
    func toDomain() -> PokemonResponse {
        .init(count: count, pokemons: results.map { $0.toPokemon() })
    }
}

public struct NamedAPIResource: Decodable {
    public let name: String
    public let url: String
    
    public init(name: String, url: String) {
        self.name = name
        self.url = url
    }
}

public extension NamedAPIResource {
    func toPokemon() -> Pokemon {
        .init(name: name, url: url)
    }
}
