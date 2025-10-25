//
//  PokemonViewModelTests.swift
//  PokedexTests
//
//  Created by Kaue de Assis Jacyntho on 25/10/25.
//

import XCTest
import Combine
@testable import Pokedex

@MainActor
final class PokemonViewModelTests: XCTestCase {
    
    var viewModel: PokemonViewModel!
    var mockAPIService: PokemonAPIServiceMock!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockAPIService = PokemonAPIServiceMock()
        viewModel = PokemonViewModel(apiService: mockAPIService)
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        cancellables = nil
        viewModel = nil
        mockAPIService = nil
        super.tearDown()
    }
    
    // MARK: - Initial State Tests
    
    func test_initialState_shouldHaveEmptyListsAndNoError() {
        XCTAssertTrue(viewModel.pokemonList.isEmpty)
        XCTAssertTrue(viewModel.pokemonDetails.isEmpty)
        XCTAssertNil(viewModel.selectedPokemon)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    // MARK: - Load Pokemon List Tests
    
    func test_loadPokemonList_withValidData_shouldLoadPokemonsAndDetails() async {
        let expectedPokemons = [
            PokemonEntry(name: "pikachu", url: "https://pokeapi.co/api/v2/pokemon/25/"),
            PokemonEntry(name: "charmander", url: "https://pokeapi.co/api/v2/pokemon/4/")
        ]
        let expectedDetails = [
            createMockPokemonDetail(name: "pikachu", id: 25),
            createMockPokemonDetail(name: "charmander", id: 4)
        ]
        
        mockAPIService.mockPokemonList = expectedPokemons
        mockAPIService.mockPokemonDetails = expectedDetails
        
        await viewModel.loadPokemonList()
        
        XCTAssertEqual(viewModel.pokemonList.count, 2)
        XCTAssertEqual(viewModel.pokemonDetails.count, 2)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.pokemonList[0].name, "pikachu")
        XCTAssertEqual(viewModel.pokemonList[1].name, "charmander")
    }
    
    func test_loadPokemonList_withNetworkError_shouldSetErrorMessage() async {
        let expectedError = NSError(domain: "TestError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Network error"])
        mockAPIService.shouldThrowError = true
        mockAPIService.mockError = expectedError
        
        await viewModel.loadPokemonList()
        
        XCTAssertTrue(viewModel.pokemonList.isEmpty)
        XCTAssertTrue(viewModel.pokemonDetails.isEmpty)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.errorMessage, "Network error")
    }
    
    func test_loadPokemonList_withDelay_shouldUpdateLoadingState() async {
        mockAPIService.delay = 0.1
        
        let expectation = XCTestExpectation(description: "Loading state changes")
        
        viewModel.$isLoading
            .dropFirst()
            .sink { isLoading in
                if !isLoading {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        await viewModel.loadPokemonList()
        
        await fulfillment(of: [expectation], timeout: 1.0)
        XCTAssertFalse(viewModel.isLoading)
    }
    
    // MARK: - Load Pokemon Details Tests
    
    func test_loadPokemonDetails_withValidName_shouldLoadPokemonDetails() async {
        let pokemonName = "pikachu"
        let expectedDetail = createMockPokemonDetail(name: pokemonName, id: 25)
        mockAPIService.mockPokemonDetails = [expectedDetail]
        
        await viewModel.loadPokemonDetails(name: pokemonName)
        
        XCTAssertNotNil(viewModel.selectedPokemon)
        XCTAssertEqual(viewModel.selectedPokemon?.name, pokemonName)
        XCTAssertEqual(viewModel.selectedPokemon?.id, 25)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func test_loadPokemonDetails_withInvalidName_shouldSetErrorMessage() async {
        let pokemonName = "invalid"
        let expectedError = NSError(domain: "TestError", code: 404, userInfo: [NSLocalizedDescriptionKey: "Pokemon not found"])
        mockAPIService.shouldThrowError = true
        mockAPIService.mockError = expectedError
        
        await viewModel.loadPokemonDetails(name: pokemonName)
        
        XCTAssertNil(viewModel.selectedPokemon)
        XCTAssertEqual(viewModel.errorMessage, "Pokemon not found")
    }
    
    // MARK: - Error Handling Tests
    
    func test_loadPokemonList_afterError_shouldResetErrorState() async {
        mockAPIService.shouldThrowError = true
        mockAPIService.mockError = NSError(domain: "TestError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Initial error"])
        
        await viewModel.loadPokemonList()
        XCTAssertNotNil(viewModel.errorMessage)
        
        mockAPIService.shouldThrowError = false
        mockAPIService.mockPokemonList = [PokemonEntry(name: "pikachu", url: "https://pokeapi.co/api/v2/pokemon/25/")]
        
        await viewModel.loadPokemonList()
        
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.pokemonList.isEmpty)
    }
    
    // MARK: - Helper Methods
    
    private func createMockPokemonDetail(name: String, id: Int) -> SelectedPokemonResponse {
        return SelectedPokemonResponse(
            sprites: PokemonSprites(
                frontDefault: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(id).png",
                other: Other(
                    home: Home(frontDefault: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/\(id).png"),
                    officialArtwork: OfficialArtwork(frontDefault: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(id).png")
                )
            ),
            name: name,
            id: id,
            weight: 60,
            height: 4,
            moves: [],
            types: [
                PokemonType(type: PokeType(name: "electric", url: "https://pokeapi.co/api/v2/type/13/"))
            ],
            stats: [
                PokemonStats(baseStat: 35, stat: PokeStat(name: "hp", url: "https://pokeapi.co/api/v2/stat/1/")),
                PokemonStats(baseStat: 55, stat: PokeStat(name: "attack", url: "https://pokeapi.co/api/v2/stat/2/"))
            ],
            abilities: [
                PokemonAbilities(ability: PokeAbility(name: "static", url: "https://pokeapi.co/api/v2/ability/9/"))
            ]
        )
    }
}
