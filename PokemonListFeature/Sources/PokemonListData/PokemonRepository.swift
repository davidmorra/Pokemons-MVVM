//
//  PokemonRepository.swift
//  Garage
//
//  Created by Davit on 15.05.24.
//

import Combine
import PokemonListDomain
import ApiClient

public class PokemonRepositoryImpl: PokemonRepository {
    private let apiClient: ApiClient
    
    public init(apiClient: ApiClient) {
        self.apiClient = apiClient
    }
    
    public func fetchPokemonts(limit: Int, offset: Int) -> AnyPublisher<PokemonResponse, Error> {
        let response: AnyPublisher<PokemonAPIResponse, Error> = apiClient.perform(PokemonAPI.page(.init(offset: offset, limit: limit)))
        return response
            .map { $0.toDomain() }
            .eraseToAnyPublisher()
    }
}
