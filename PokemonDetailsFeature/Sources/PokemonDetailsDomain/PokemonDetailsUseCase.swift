//
//  File.swift
//  
//
//  Created by Davit on 17.05.24.
//

import Foundation
import Combine

public protocol PokemonDetailsUseCase {
    func fetchDetails(for id: Int) -> AnyPublisher<PokemonDetails, Error>
}

public class PokemonDetailsUseCaseImpl: PokemonDetailsUseCase {
    private let repository: PokemonDetailsRepository
    
    public init(repository: PokemonDetailsRepository) {
        self.repository = repository
    }
    
    public func fetchDetails(for id: Int) -> AnyPublisher<PokemonDetails, Error> {
        repository.fetchDetails(for: id)
    }
}
