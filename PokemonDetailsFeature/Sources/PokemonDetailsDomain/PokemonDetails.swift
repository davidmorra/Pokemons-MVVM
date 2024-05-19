//
//  File.swift
//
//
//  Created by Davit on 17.05.24.
//

import Foundation

public struct PokemonDetails {
    public let id: Int
    public let name: String
    public let imageURL: URL?
    public let stats: [StatModel]
    public let generations: [PokemonGeneration]
    
    public init(
        id: Int,
        name: String,
        imageURL: URL?,
        stats: [StatModel],
        generations: [PokemonGeneration]
    ) {
        self.id = id
        self.name = name
        self.imageURL = imageURL
        self.stats = stats
        self.generations = generations
    }
}

public struct PokemonGeneration {
    public let generation: GenerationType
    public let imageUrl: String
    
    public init?(generation: GenerationType, imageUrl: String?) {
        guard let url = imageUrl else { return nil }
        self.generation = generation
        self.imageUrl = url
    }
}

public enum GenerationType: String {
    case generationI
    case generationIi
    case generationIii
    case generationIv
    case generationV
    case generationVi
    case generationVii
    case generationViii
}

public struct StatModel {
    public let type: StatType
    public let value: String
    
    public init?(type: String, value: String) {
        guard let type = StatType(rawValue: type) else { return nil }
        
        self.type = type
        self.value = value
    }
}

public enum StatType: String {
    case hp
    case attack
    case defense
    case speed
    case speacialAttack
    case speacialDefense
    
    public init?(rawValue: String) {
        switch rawValue {
        case "hp": self = .hp
        case "attack": self = .attack
        case "defense": self = .defense
        case "speed": self = .speed
        case "special-attack": self = .speacialAttack
        case "special-defense": self = .speacialDefense
        default: return nil
        }
    }
    
    public var sortIndex: Int {
        switch self {
        case .hp: return 0
        case .attack: return 1
        case .defense: return 2
        case .speed: return 3
        case .speacialAttack: return 4
        case .speacialDefense: return 5
        }
    }

    public var title: String {
        switch self {
        case .hp: return "Health"
        case .attack: return "Attack"
        case .defense: return "Defense"
        case .speed: return "Speed"
        case .speacialAttack: return "Special Attack"
        case .speacialDefense: return "Special Defense"
        }
    }
    
    public var imageName: String {
        switch self {
        case .hp: return "heart"
        case .attack: return "star"
        case .defense: return "shield"
        case .speed: return "bolt"
        case .speacialAttack: return "star.fill"
        case .speacialDefense: return "checkerboard.shield"
        }
    }
}
