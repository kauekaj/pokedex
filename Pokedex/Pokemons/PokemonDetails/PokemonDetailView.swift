//
//  PokemonDetailView.swift
//  Pokedex
//
//  Created by Kaue de Assis Jacyntho on 25/10/25.
//

import SwiftUI

struct PokemonDetailView: View {
    let model: PokemonDetailModel
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTab: DetailsTab = .about
    @State private var isFavorite = false
    
    var body: some View {
        ZStack {
            backgroundColor
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
                    contentSection
                    detailsCardSection
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    // MARK: - Header Section
    
    @ViewBuilder
    private var contentSection: some View {
        VStack(spacing: 16) {
            headerButtons
            pokemonDetails
            pokemonImage
        }
        .frame(height: 400)
    }
    
    @ViewBuilder
    private var headerButtons: some View {
        HStack {
            Button(action: { dismiss() }) {
                Image(systemName: "arrow.left")
                    .font(.title2)
                    .foregroundColor(.white)
            }
            
            Spacer()
            
            FavoriteButton(isFavorite: $isFavorite)
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    @ViewBuilder
    private var pokemonDetails: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(model.pokemon.name.capitalized)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                if let id = model.pokemonDetail?.id {
                    Text("#\(String(format: "%03d", id))")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white.opacity(0.8))
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
        
        if let types = model.pokemonDetail?.allTypes, !types.isEmpty {
            HStack {
                ForEach(types, id: \.self) { type in
                    TypeChipView(type: type)
                }
                Spacer()
            }
            .padding(.horizontal, 20)
        }
    }
    
    @ViewBuilder
    private var pokemonImage: some View {
            ImageLoaderView(
                urlString: model.imageURL?.absoluteString,
                resizingMode: ContentMode.fit
            )
            .frame(width: 200, height: 200)
            .cornerRadius(12)
    }
    
    // MARK: - Details Card Section
    
    @ViewBuilder
    private var detailsCardSection: some View {
        VStack(spacing: 0) {
            tabNavigation
            tabContent
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 20)
        .background(Color(.systemBackground))
        .clipShape(
            RoundedRectangle(cornerRadius: 20)
        )
    }
    
    @ViewBuilder
    private var tabNavigation: some View {
        HStack(spacing: 0) {
            ForEach(DetailsTab.allCases, id: \.self) { tab in
                Button(action: { selectedTab = tab }) {
                    VStack(spacing: 8) {
                        Text(tab.title)
                            .font(.headline)
                            .foregroundColor(selectedTab == tab ? tabColor : .secondary)
                        
                        Rectangle()
                            .fill(selectedTab == tab ? tabColor : Color.clear)
                            .frame(height: 2)
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }
    
    @ViewBuilder
    private var tabContent: some View {
        switch selectedTab {
        case .about:
            AboutTabView(pokemonDetail: model.pokemonDetail)
        case .baseStats:
            BaseStatsTabView(pokemonDetail: model.pokemonDetail)
        }
    }
    
    // MARK: - Computed Properties
    
    private var backgroundColor: Color {
        guard let primaryType = model.pokemonDetail?.primaryType else {
            return .gray
        }
        return Color.pokemonTypeColor(for: primaryType)
    }
    
    private var tabColor: Color {
        guard let primaryType = model.pokemonDetail?.primaryType else {
            return .blue
        }
        return Color.pokemonTypeColor(for: primaryType)
    }
}
