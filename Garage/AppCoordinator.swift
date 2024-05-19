//
//  AppCoordinator.swift
//  Garage
//
//  Created by Davit on 16.05.24.
//

import UIKit
import PokemonListUI
import PokemonDetailsUI

protocol Coordinator {
    var navigationController: UINavigationController { get set }
    
    func start()
}

class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    let appDIContainer: AppDiContainer
    
    init(appDIContainer: AppDiContainer, navigationController: UINavigationController) {
        self.appDIContainer = appDIContainer
        self.navigationController = navigationController
    }
    
    func start() {
        showPokemonListVC()
    }
    
    func showPokemonListVC() {
        let container = appDIContainer.makePokemonDiContainer()
        let pokemonListVC = container.makePokemonListVC { [unowned self] pokemon in
            self.showDetails(.init(id: pokemon.id, name: pokemon.name, imageUrl: pokemon.imageURL))
        }
        navigationController.pushViewController(pokemonListVC, animated: true)

    }
    
    func showDetails(_ pokemon: PokemonDetailsViewModel.Pokemon) {
        let container = appDIContainer.makePokemonDetailsDiContainer()
        let detailsFlowCoordinator = container.makePokemonDetailsVC(for: pokemon)
        
        navigationController.pushViewController(detailsFlowCoordinator, animated: true)
    }
}
