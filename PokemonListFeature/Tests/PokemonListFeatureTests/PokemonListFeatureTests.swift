import XCTest
@testable import PokemonListData
@testable import PokemonListUI
@testable import PokemonListDomain
import Combine

struct DummyError: Error { }

class StubPokemonListUseCase: PokemonListUseCase {
    let pokemons: [Pokemon]
    let totalCount: Int
    let error: Error?
    
    init(pokemons: [Pokemon] = [], totalCount: Int = 5, error: Error? = nil) {
        self.pokemons = pokemons
        self.totalCount = totalCount
        self.error = error
    }
    
    func loadPokemons(with request: PokemonListUseCaseRequestValue) -> AnyPublisher<PokemonResponse, Error> {
        if let error {
            return Fail(error: error)
                .eraseToAnyPublisher()
            
            
        } else {
            return Just(PokemonResponse(
                count: totalCount,
                pokemons: pokemons)
            )
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        }
    }
}

final class PokemonListFeatureTests: XCTestCase {
    var cancellables = Set<AnyCancellable>()
    
    var pokemons: [Pokemon] = [
        .init(name: "1", url: ""),
        .init(name: "2", url: ""),
        .init(name: "3", url: ""),
        .init(name: "4", url: ""),
        .init(name: "5", url: "")
    ]
    
    override func setUp() {
        super.setUp()
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        cancellables = []
        super.tearDown()
    }
    
    
    func test_vm_shouldNotHaveMorePagesIfTotalCountAndPokemonsCountIsFive() {
        let sut = makeSUT(pokemons, totalCount: 5)
        
        sut.viewDidLoad()
        
        sut.$pokemons
            .sink(receiveValue: { pokemons in
                XCTAssertEqual(pokemons.count, 5)
                XCTAssertFalse(sut.hasMorePages)
            })
            .store(in: &cancellables)
    }
    
    func test_vm_shouldHaveMorePagesIfTotalCountIsGreaterThatReceivedPokemons() {
        let sut = makeSUT(pokemons, totalCount: 100)

        sut.viewDidLoad()
        
        sut.$pokemons
            .sink(receiveValue: { pokemons in
                XCTAssertTrue(sut.hasMorePages)
            })
            .store(in: &cancellables)
    }
    
    func test_vm_whenPokemonIsSelectedShouldCallOnSelect() {
        let expectation = expectation(description: "onSelect called")
        
        let sut = makeSUT(pokemons, totalCount: 100) {
            expectation.fulfill()
        }
        
        sut.onSelect(PokemonListItemViewModel(from: pokemons[0]))
        
        waitForExpectations(timeout: 1)
    }
    
    func test_vm_Error() {
        let expectation = expectation(description: "received error")

        let sut = makeSUT(error: DummyError()) {
            expectation.fulfill()
        }
        
        sut.$error
            .sink { error in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 1)
    }
    
    func makeSUT(_ pokemons: [Pokemon] = [],
                 totalCount: Int = 5,
                 error: Error? = nil,
                 onSelect: (() -> Void)? = nil
    ) -> PokemonListViewModel {
        let vm = PokemonListViewModel(
            useCase: StubPokemonListUseCase(
                pokemons: pokemons,
                totalCount: totalCount,
                error: error
            ),
            onSelect: { _ in
                onSelect?()
            }
        )
        
        return vm
    }
}
