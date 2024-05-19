//
//  File.swift
//  
//
//  Created by Davit on 17.05.24.
//

import ApiClient
import PokemonDetailsDomain
import PokemonDetailsData
import Shared

public class PokemonDetailsDiContainer {
    private let apiClient: ApiClient
    private let imageLoaderRepository: ImageLoaderRepository
    
    public init(apiClient: ApiClient, imageLoaderRepository: ImageLoaderRepository) {
        self.apiClient = apiClient
        self.imageLoaderRepository = imageLoaderRepository
    }

    public func makePokemonDetailsVC(for pokemonId: PokemonDetailsViewModel.Pokemon) -> PokemonDetailsViewController {
        return PokemonDetailsViewController(
            viewmodel: makePokemonDetailsViewModel(for: pokemonId),
            imageLoaderRepository: imageLoaderRepository
        )
    }
    
    public func makePokemonDetailsViewModel(for pokemonId: PokemonDetailsViewModel.Pokemon) -> PokemonDetailsViewModel {
        return PokemonDetailsViewModel(
            pokemon: pokemonId,
            useCase: makePokemonDetailsUseCase()
        )
    }
    
    func makePokemonDetailsUseCase() -> PokemonDetailsUseCase {
        return PokemonDetailsUseCaseImpl(
            repository: makePokemonDetailsRepository()
        )
    }
    
    func makePokemonDetailsRepository() -> PokemonDetailsRepository {
        return PokemonDetailsRepositoryImpl(
            apiClient: apiClient
        )
    }
}
