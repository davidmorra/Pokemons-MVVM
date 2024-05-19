//
//  AppDiContainer.swift
//  Garage
//
//  Created by Davit on 16.05.24.
//

import Foundation
import PokemonListUI
import PokemonDetailsUI
import ApiClient
import Shared

class AppDiContainer {
    private let apiClient: ApiClient = {
        return ApiClient(session: URLSession.shared)
    }()
    
    private let imageClient: ApiClient = {
        return ApiClient(
            session: URLSession.shared,
            configuration: NetworkConfigurationImpl(baseURL: "raw.githubusercontent.com"),
            decoder: DataResponseDecoder()
        )
    }()
        
    func makePokemonDiContainer() -> PokemonListDiContainer {
        return PokemonListDiContainer(apiClient: apiClient, imageLoaderRepository: makeImageLoaderRepository())
    }
    
    func makePokemonDetailsDiContainer() -> PokemonDetailsDiContainer {
        return PokemonDetailsDiContainer(apiClient: apiClient, imageLoaderRepository: makeImageLoaderRepository())
    }
    
    
    func makeImageLoaderRepository() -> ImageLoaderRepository {
        return DefaultImageLoaderRepository(apiClient: imageClient)
    }
}
