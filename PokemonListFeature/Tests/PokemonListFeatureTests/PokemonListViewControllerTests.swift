//
//  PokemonListViewControllerTests.swift
//  
//
//  Created by Davit on 19.05.24.
//

import XCTest
@testable import PokemonListUI
@testable import PokemonListData
@testable import PokemonListDomain
import Combine
import Shared

class DummyImageLoaderRepository: ImageLoaderRepository {
    func loadImage(path: String) -> AnyPublisher<Data, Error> {
        Just(Data())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func loadImage(for pokemonId: Int) -> AnyPublisher<Data, Error> {
        Just(Data())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}

final class PokemonListViewControllerTests: XCTestCase {
    
    func test_collectionViewShouldHaveFiveItemsInSectionWhenViewDidLoadIsCalled() {
        let vm = PokemonListViewModel(useCase: StubPokemonListUseCase(pokemons: [
            .init(name: "1", url: ""),
            .init(name: "2", url: ""),
            .init(name: "3", url: ""),
            .init(name: "4", url: ""),
            .init(name: "5", url: "")
        ])) { _ in }
        let vc = PokemonListViewController(viewmodel: vm, imageLoaderRepository: DummyImageLoaderRepository())
        
        vc.loadViewIfNeeded()
        
        XCTAssertEqual(vc.numberOfItems, 5)
    }
    
    func test_onSelect_shouldCallMethodInViewModel() {
        let exp = expectation(description: "on select called")
        let vm = PokemonListViewModel(useCase: StubPokemonListUseCase(pokemons: [
            .init(name: "pikachu", url: ""),
            .init(name: "2", url: ""),
            .init(name: "3", url: ""),
            .init(name: "4", url: ""),
            .init(name: "5", url: "")
        ])) { pokemon in
            exp.fulfill()
            XCTAssertEqual(pokemon.name, "pikachu")
        }
        let vc = PokemonListViewController(viewmodel: vm, imageLoaderRepository: DummyImageLoaderRepository())
        
        vc.loadViewIfNeeded()
        vc.collectionView.delegate?.collectionView?(vc.collectionView, didSelectItemAt: .init(row: 0, section: 0))
        
        wait(for: [exp])
    }
}

extension PokemonListViewController {
    var numberOfItems: Int {
        collectionView.numberOfItems(inSection: 0)
    }
}
