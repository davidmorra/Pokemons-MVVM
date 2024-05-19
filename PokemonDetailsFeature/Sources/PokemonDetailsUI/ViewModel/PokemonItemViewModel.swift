//
//  File.swift
//  
//
//  Created by Davit on 17.05.24.
//

import Foundation
import PokemonDetailsDomain

struct PokemonStatsItem: Hashable {
    let iconName: String
    let statTitle: String
    let statValue: String
    
    init(_ stat: StatModel) {
        self.iconName = stat.type.imageName
        self.statTitle = stat.type.title
        self.statValue = stat.value
    }
}

struct GenerationItem: Hashable {
    let title: String
    let imageUrl: URL?
    
    init(_ generation: PokemonGeneration) {
        self.title = generation.generation.rawValue
        self.imageUrl = URL(string: generation.imageUrl)
    }
}

struct PokemonDetailsItemViewModel: Hashable {
    let id: Int
    let name: String
    let imageUrl: URL?
    let stats: [PokemonStatsItem]
    let generations: [GenerationItem]
    
    init(_ pokemon: PokemonDetails) {
        self.id = pokemon.id
        self.name = pokemon.name
        self.imageUrl = pokemon.imageURL
        self.stats = pokemon.stats.map(PokemonStatsItem.init)
        self.generations = pokemon.generations.map(GenerationItem.init)
    }
}
