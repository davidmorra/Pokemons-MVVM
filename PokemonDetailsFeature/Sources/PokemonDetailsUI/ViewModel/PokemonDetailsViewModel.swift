//
//  File.swift
//  
//
//  Created by Davit on 17.05.24.
//

import PokemonDetailsDomain
import Foundation
import Combine

public class PokemonDetailsViewModel {
    private let useCase: PokemonDetailsUseCase
    private(set) var pokemon: Pokemon
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published var stats: [PokemonStatsItem] = []
    @Published var generations: [GenerationItem] = []
    @Published var isLoading = false
    
    public init(
        pokemon: Pokemon,
        useCase: PokemonDetailsUseCase
    ) {
        self.pokemon = pokemon
        self.useCase = useCase
    }
    
    func viewDidLoad() {
        loadDetails()
    }
    
    private func loadDetails() {
        isLoading = true
        useCase.fetchDetails(for: pokemon.id)
            .sink { [weak self] completion in
                
                self?.isLoading = false
            } receiveValue: { [weak self] pokemonDetails in
                self?.stats = pokemonDetails.stats
                    .sorted(by: { $0.type.sortIndex < $1.type.sortIndex })
                    .map(PokemonStatsItem.init)
                
                self?.generations = pokemonDetails.generations.map(GenerationItem.init)
            }
            .store(in: &cancellables)
    }
    
    public struct Pokemon {
        let id: Int
        let name: String
        let imageUrl: URL?
        
        public init(id: Int, name: String, imageUrl: URL?) {
            self.id = id
            self.name = name
            self.imageUrl = imageUrl
        }
    }
}
