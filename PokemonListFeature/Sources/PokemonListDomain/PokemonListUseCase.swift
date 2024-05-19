//
//  File.swift
//  
//
//  Created by Davit on 15.05.24.
//

import Combine

public protocol PokemonRepository {
    func fetchPokemonts(limit: Int, offset: Int) -> AnyPublisher<PokemonResponse, Error>
}

public protocol PokemonListUseCase {
    func loadPokemons(with request: PokemonListUseCaseRequestValue) -> AnyPublisher<PokemonResponse, Error>
}

public class PokemonListUseCaseImpl: PokemonListUseCase {
    private let repository: PokemonRepository
    
    public init(repository: PokemonRepository) {
        self.repository = repository
    }
    
    public func loadPokemons(with request: PokemonListUseCaseRequestValue) -> AnyPublisher<PokemonResponse, Error> {
        repository.fetchPokemonts(limit: request.limit, offset: request.offset)
    }
}

public struct PokemonListUseCaseRequestValue {
    public let limit: Int
    public let offset: Int
    
    public init(limit: Int, offset: Int) {
        self.limit = limit
        self.offset = offset
    }
}
