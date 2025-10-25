//
//  PokemonListView.swift
//  Pokedex
//
//  Created by Kaue de Assis Jacyntho on 25/10/25.
//

import SwiftUI

struct PokemonListView<ViewModel: PokemonViewModelProtocol & ObservableObject>: View {
    @StateObject private var viewModel: ViewModel
    @State private var searchText = ""
    
    init(viewModel: ViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var filteredPokemon: [PokemonEntry] {
        if searchText.isEmpty {
            return viewModel.pokemonList
        } else {
            return viewModel.pokemonList.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: .zero) {
                headerSection
                
                ScrollView {
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 20) {
                        ForEach(filteredPokemon) { pokemon in
                            NavigationLink(destination: PokemonDetailView(
                                model: createPokemonDetailModel(for: pokemon)
                            )) {
                                PokemonCardView(pokemon: pokemon, viewModel: viewModel)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 20)
                }
            }
            .onFirstAppear {
                await viewModel.loadPokemonList()
            }
        }
    }
    
    @ViewBuilder
    private var headerSection: some View {
        VStack(spacing: 12) {
            Text("Pokédex")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text("Gotta Catch 'Em All")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            SearchBarView(text: $searchText, hintText: "Search Pokémon...")
                .padding(.horizontal, 16)
        }
        .padding(.top, 20)
        .padding(.bottom, 16)
    }
    
    // MARK: - Helper Methods
    
    private func createPokemonDetailModel(for pokemon: PokemonEntry) -> PokemonDetailModel {
        let pokemonDetail = viewModel.pokemonDetails.first { $0.name?.lowercased() == pokemon.name.lowercased() }
        return PokemonDetailModel(pokemon: pokemon, pokemonDetail: pokemonDetail)
    }
}
