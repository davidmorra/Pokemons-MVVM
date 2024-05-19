import XCTest
@testable import Common

final class CommonTests: XCTestCase {
    
    func test_Generate_idFromURL() {
        XCTAssertEqual(Generate.Id(from: "https://pokeapi.co/api/v2/pokemon/42/"), 42)
    }
    
    func test_Generate_generationImagePath() {
        let url = URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-i/red-blue/back/42.png")
        XCTAssertEqual(
            Generate.generationImagePath(from: url),
            "/PokeAPI/sprites/master/sprites/pokemon/versions/generation-i/red-blue/back/42.png")
    }
    
}
