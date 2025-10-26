//
//  PokemonCardView.swift
//  Pokedex
//
//  Created by Kaue de Assis Jacyntho on 25/10/25.
//

import SwiftUI

struct PokemonCardView<ViewModel: PokemonViewModelProtocol>: View {
    let pokemon: PokemonEntry
    @ObservedObject var viewModel: ViewModel
    @State private var isFavorite = false
    
    private var pokemonDetail: SelectedPokemonResponse? {
        viewModel.pokemonDetails.first { $0.name?.lowercased() == pokemon.name.lowercased() }
    }
    
    var body: some View {
        VStack(spacing: 12) {
            headerSection
            imageSection
            typesSection
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 20)
        .frame(height: 180)
        .background(backgroundColor)
        .cornerRadius(20)
        .shadow(color: backgroundColor.opacity(0.2), radius: 12, x: 0, y: 6)
    }
    
    // MARK: - ViewBuilder
    
    @ViewBuilder
    private var headerSection: some View {
        HStack {
            Text(pokemon.name.capitalized)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Spacer()
            
            FavoriteButton(isFavorite: $isFavorite, font: .caption)
                .foregroundColor(.white.opacity(0.7))
        }
    }
    
    @ViewBuilder
    private var typesSection: some View {
        if let types = pokemonDetail?.allTypes, !types.isEmpty {
            HStack {
                ForEach(types, id: \.self) { type in
                    TypeChipView(type: type)
                }
            }
        }
    }
    
    @ViewBuilder
    private var imageSection: some View {
            ImageLoaderView(
                urlString: pokemonDetail?.sprites?.other?.officialArtwork?.frontDefault,
                resizingMode: ContentMode.fit
            )
            .frame(width: 80, height: 80)
            .cornerRadius(8)
    }
        
    private var backgroundColor: Color {
        guard let primaryType = pokemonDetail?.primaryType else {
            return .gray
        }
        return Color.pokemonTypeColor(for: primaryType)
    }
}
