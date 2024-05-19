//
//  PokemonListViewModel.swift
//  Garage
//
//  Created by Davit on 15.05.24.
//

import Foundation
import PokemonListDomain
import Combine

public struct PokemonListItemViewModel: Hashable {
    public let id: Int
    public let name: String
    public let imageURL: URL?
    
    init(from pokemon: Pokemon) {
        self.name = pokemon.name
        self.id = pokemon.id
        self.imageURL = pokemon.imageURL
    }
}

public class PokemonListViewModel {
    @Published private(set) var pokemons: [PokemonListItemViewModel] = []
    @Published private(set) var error: Error?
    @Published private(set) var isLoading = false
    
    private var cancellables = Set<AnyCancellable>()
    private let useCase: PokemonListUseCase
    
    private var offset = 0
    private let limit = 20
    private var totalCount = 0
    
    var hasMorePages: Bool {
        guard totalCount != 0 else { return true }
        return totalCount > pokemons.count
    }
    
    private var onSelect: ((PokemonListItemViewModel) -> Void)?
    
    public init(useCase: PokemonListUseCase, onSelect: @escaping (PokemonListItemViewModel) -> Void) {
        self.useCase = useCase
        self.onSelect = onSelect
    }
    
    func viewDidLoad() {
        isLoading = true
        loadPokemons()
    }
    
    func loadNextPage() {
        guard hasMorePages else { return }
        offset += 20
        loadPokemons()
    }
    
    func onSelect(_ pokemon: PokemonListItemViewModel) {
        onSelect?(pokemon)
    }
    
    func reset() {
        offset = 0
        pokemons.removeAll()
        loadPokemons()
    }
    
    private func loadPokemons() {
        useCase.loadPokemons(with: .init(limit: limit, offset: offset))
            .sink { [weak self] completion in
                self?.isLoading = false
                
                switch completion {
                case let .failure(error): 
                    self?.error = error
                    
                case .finished: ()
                }
            } receiveValue: { [weak self] response in
                guard let self else { return }
                self.totalCount = response.count
                self.pokemons = self.pokemons + response.pokemons.map(PokemonListItemViewModel.init)
            }
            .store(in: &cancellables)
    }
}
