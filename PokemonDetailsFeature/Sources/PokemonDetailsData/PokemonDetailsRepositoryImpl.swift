//
//  File.swift
//  
//
//  Created by Davit on 17.05.24.
//

import ApiClient
import Combine
import PokemonDetailsDomain

public class PokemonDetailsRepositoryImpl: PokemonDetailsRepository {
    private let apiClient: ApiClient
    
    public init(apiClient: ApiClient) {
        self.apiClient = apiClient
    }
    
    public func fetchDetails(for id: Int) -> AnyPublisher<PokemonDetails, Error> {
        let response: AnyPublisher<PokemonDetailResponse, Error> = apiClient.perform(PokemonAPI.id(id))
        return response
            .map { $0.toDomain() }
            .eraseToAnyPublisher()
    }
}
