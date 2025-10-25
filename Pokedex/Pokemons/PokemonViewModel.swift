//
//  PokemonViewModelProtocol.swift
//  Pokedex
//
//  Created by Kaue de Assis Jacyntho on 25/10/25.
//

import SwiftUI

@MainActor
protocol PokemonViewModelProtocol: ObservableObject {
    var pokemonList: [PokemonEntry] { get }
    var pokemonDetails: [SelectedPokemonResponse] { get }
    var selectedPokemon: SelectedPokemonResponse? { get }
    var isLoading: Bool { get }
    var errorMessage: String? { get }
    
    func loadPokemonList() async
    func loadPokemonDetails(name: String) async
}

@MainActor
class PokemonViewModel: PokemonViewModelProtocol {
    @Published var pokemonList: [PokemonEntry] = []
    @Published var pokemonDetails: [SelectedPokemonResponse] = []
    @Published var selectedPokemon: SelectedPokemonResponse?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let apiService: PokemonAPIServiceProtocol
    
    init(apiService: PokemonAPIServiceProtocol) {
        self.apiService = apiService
    }
    
    func loadPokemonList() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let basicList = try await apiService.getData()
            pokemonList = basicList
            
            await loadPokemonDetails(for: basicList)
            
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    private func loadPokemonDetails(for pokemons: [PokemonEntry]) async {
        pokemonDetails = []
        
        let details = await withTaskGroup(of: SelectedPokemonResponse?.self) { group in
            var results: [SelectedPokemonResponse] = []
            
            for pokemon in pokemons {
                group.addTask {
                    try? await self.apiService.getPokemonDetails(name: pokemon.name)
                }
            }
            
            for await result in group {
                if let detail = result {
                    results.append(detail)
                }
            }
            
            return results.sorted { ($0.id ?? 0) < ($1.id ?? 0) }
        }
        
        pokemonDetails = details
    }
    
    func loadPokemonDetails(name: String) async {
        do {
            let details = try await apiService.getPokemonDetails(name: name)
            selectedPokemon = details
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
