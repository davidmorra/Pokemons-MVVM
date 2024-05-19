//
//  File.swift
//  
//
//  Created by Davit on 17.05.24.
//

import Foundation
import PokemonDetailsDomain
import Common

// MARK: - PokemonDetailResponse
struct PokemonDetailResponse: Decodable {
    let id: Int
    let name: String
    let order: Int
    let stats: [Stat]
    let sprites: Sprites
}

extension PokemonDetailResponse {
    func toDomain() -> PokemonDetails {
        let stats: [StatModel] = stats.compactMap { StatModel(type: $0.stat.name, value: String($0.baseStat)) }
        
        return .init(
            id: id,
            name: name,
            imageURL: Generate.imageURL(from: id),
            stats: stats,
            generations: sprites.versions.toDomain())
    }
}

// MARK: - GenerationV
struct GenerationV: Decodable {
    let blackWhite: FrontImageResourse
}

struct GenerationVi: Decodable {
    let omegarubyAlphasapphire: FrontImageResourse
    let xY: FrontImageResourse
}

// MARK: - GenerationIv
struct GenerationIv: Decodable {
    let diamondPearl: FrontImageResourse
    let heartgoldSoulsilver: FrontImageResourse
    let platinum: FrontImageResourse
}

// MARK: - Versions
struct Versions: Decodable {
    let generationI: GenerationI
    let generationIi: GenerationIi
    let generationIii: GenerationIii
    let generationIv: GenerationIv
    let generationV: GenerationV
    let generationVi: GenerationVi
    let generationVii: GenerationVii
    let generationViii: GenerationViii
}

extension Versions {
    func toDomain() -> [PokemonGeneration] {
        [
            .init(generation: .generationI, imageUrl: generationI.redBlue.frontDefault),
            .init(generation: .generationI, imageUrl: generationI.yellow.frontDefault),
            .init(generation: .generationIi, imageUrl: generationIi.crystal.frontDefault),
            .init(generation: .generationIi, imageUrl: generationIi.gold.frontDefault),
            .init(generation: .generationIi, imageUrl: generationIi.silver.frontDefault),
            .init(generation: .generationIii, imageUrl: generationIii.fireredLeafgreen.frontDefault),
            .init(generation: .generationIii, imageUrl: generationIii.rubySapphire.frontDefault),
            .init(generation: .generationIv, imageUrl: generationIv.diamondPearl.frontDefault),
            .init(generation: .generationIv, imageUrl: generationIv.heartgoldSoulsilver.frontDefault),
            .init(generation: .generationIv, imageUrl: generationIv.platinum.frontDefault),
            .init(generation: .generationV, imageUrl: generationV.blackWhite.frontDefault),
            .init(generation: .generationVi, imageUrl: generationVi.omegarubyAlphasapphire.frontDefault),
            .init(generation: .generationVi, imageUrl: generationVi.xY.frontDefault),
            .init(generation: .generationVii, imageUrl: generationVii.icons.frontDefault),
            .init(generation: .generationVii, imageUrl: generationVii.ultraSunUltraMoon.frontDefault),
            .init(generation: .generationViii, imageUrl: generationViii.icons.frontDefault),
        ].compactMap { $0 }
    }
}

struct Sprites: Decodable {
    let versions: Versions
}

struct GenerationI: Decodable {
    let redBlue: FrontImageResourse
    let yellow: FrontImageResourse
}

struct TransparentImageResourse: Decodable {
    let frontTransparent: String
}

struct FrontImageResourse: Decodable {
    let frontDefault: String
}

struct GenerationIi: Decodable {
    let crystal: FrontImageResourse
    let gold: FrontImageResourse
    let silver: FrontImageResourse
}

struct GenerationIii: Decodable {
    let fireredLeafgreen: FrontImageResourse
    let rubySapphire: FrontImageResourse
}

struct GenerationVii: Decodable {
    let icons: FrontImageResourse
    let ultraSunUltraMoon: FrontImageResourse
}

struct GenerationViii: Decodable {
    let icons: FrontImageResourse
}

struct Stat: Decodable {
    let baseStat: Int
    let effort: Int
    let stat: NamedAPIResource
}

public struct NamedAPIResource: Decodable {
    public let name: String
    public let url: String
    
    public init(name: String, url: String) {
        self.name = name
        self.url = url
    }
}
