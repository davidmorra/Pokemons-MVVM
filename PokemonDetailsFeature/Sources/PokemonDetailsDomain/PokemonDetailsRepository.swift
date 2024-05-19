//
//  File.swift
//  
//
//  Created by Davit on 17.05.24.
//

import Combine

public protocol PokemonDetailsRepository {
    func fetchDetails(for id: Int) -> AnyPublisher<PokemonDetails, Error>
}
