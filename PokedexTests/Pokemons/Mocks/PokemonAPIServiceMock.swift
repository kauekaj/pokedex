//
//  TestConfiguration.swift
//  PokedexTests
//
//  Created by Kaue de Assis Jacyntho on 25/10/25.
//

import Foundation
import XCTest
@testable import Pokedex

// MARK: - Mock PokemonAPIService

class PokemonAPIServiceMock: PokemonAPIServiceProtocol {
    var mockPokemonList: [PokemonEntry] = []
    var mockPokemonDetails: [SelectedPokemonResponse] = []
    var shouldThrowError = false
    var mockError: Error?
    var delay: TimeInterval = 0
    
    func getData() async throws -> [PokemonEntry] {
        if shouldThrowError {
            throw mockError ?? NSError(domain: "MockError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Mock error"])
        }
        
        if delay > 0 {
            try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
        }
        
        return mockPokemonList
    }
    
    func getPokemonDetails(name: String) async throws -> SelectedPokemonResponse {
        if shouldThrowError {
            throw mockError ?? NSError(domain: "MockError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Mock error"])
        }
        
        if delay > 0 {
            try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
        }
        
        guard let detail = mockPokemonDetails.first(where: { $0.name?.lowercased() == name.lowercased() }) else {
            throw NSError(domain: "MockError", code: 404, userInfo: [NSLocalizedDescriptionKey: "Pokemon not found"])
        }
        
        return detail
    }
}

// MARK: - Test Utilities

extension XCTestCase {
    func waitForAsyncOperation<T>(
        timeout: TimeInterval = 1.0,
        operation: @escaping () async -> T
    ) async -> T {
        return await withCheckedContinuation { continuation in
            Task {
                let result = await operation()
                continuation.resume(returning: result)
            }
        }
    }
}

// MARK: - Mock Data Factory

struct MockDataFactory {
    static func createPokemonEntry(name: String, id: Int) -> PokemonEntry {
        return PokemonEntry(
            name: name,
            url: "https://pokeapi.co/api/v2/pokemon/\(id)/"
        )
    }
    
    static func createPokemonDetail(name: String, id: Int, types: [String] = ["electric"]) -> SelectedPokemonResponse {
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
            types: types.map { PokemonType(type: PokeType(name: $0, url: "https://pokeapi.co/api/v2/type/\($0.hashValue)/")) },
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
