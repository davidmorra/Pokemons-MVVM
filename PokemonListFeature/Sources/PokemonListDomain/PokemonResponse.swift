//
//  PokemonResponse.swift
//  Garage
//
//  Created by Davit on 15.05.24.
//

import Foundation
import Common

public struct Pokemon {
    public let id: Int
    public let name: String
    public let imageURL: URL?
    
    public init(name: String, url: String) {
        self.id = Generate.Id(from: url)
        self.name = name
        self.imageURL = Generate.imageURL(from: id)
    }
}

public struct PokemonResponse {
    public let count: Int
    public let pokemons: [Pokemon]
    
    public init(count: Int, pokemons: [Pokemon]) {
        self.count = count
        self.pokemons = pokemons
    }
}
