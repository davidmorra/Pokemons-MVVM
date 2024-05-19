//
//  File.swift
//  
//
//  Created by Davit on 16.05.24.
//

import Foundation
import PokemonListDomain
import PokemonListData
import ApiClient
import Shared

public class PokemonListDiContainer {
    private let apiClient: ApiClient
    private let imageLoaderRepository: ImageLoaderRepository
    
    public init(apiClient: ApiClient, imageLoaderRepository: ImageLoaderRepository) {
        self.apiClient = apiClient
        self.imageLoaderRepository = imageLoaderRepository
    }

    func makePokemonListUseCase() -> PokemonListUseCase {
        return PokemonListUseCaseImpl(repository: makePokemonRepository())
    }
    
    func makePokemonRepository() -> PokemonRepository {
        return PokemonRepositoryImpl(apiClient: apiClient)
    }
}

extension PokemonListDiContainer {
    public func makePokemonListVC(_ onSelect: @escaping (PokemonListItemViewModel) -> Void) -> PokemonListViewController {
        return PokemonListViewController(
            viewmodel: makePokemonListViewModel(onSelect),
            imageLoaderRepository: imageLoaderRepository)
    }
    
    public func makePokemonListViewModel(_ onSelect: @escaping (PokemonListItemViewModel) -> Void) -> PokemonListViewModel {
        return PokemonListViewModel(
            useCase: makePokemonListUseCase(),
            onSelect: onSelect)
    }
}
