//
//  AboutTabView.swift
//  Pokedex
//
//  Created by Kaue de Assis Jacyntho on 25/10/25.
//

import SwiftUI

struct AboutTabView: View {
    let pokemonDetail: SelectedPokemonResponse?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if let detail = pokemonDetail {
                DetailRow(title: "Species", value: "Seed")
                DetailRow(title: "Height", value: formatHeight(detail.height))
                DetailRow(title: "Weight", value: formatWeight(detail.weight))
                DetailRow(title: "Abilities", value: formatAbilities(detail.abilities))
                
                Divider()
                    .padding(.vertical, 8)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 20)
    }
    
    private func formatHeight(_ height: Int?) -> String {
        guard let height = height else { return "Unknown" }
        let feet = height / 10
        let inches = Double(height % 10) / 10.0
        return "\(feet)'\(String(format: "%.1f", inches))\" (\(height) cm)"
    }
    
    private func formatWeight(_ weight: Int?) -> String {
        guard let weight = weight else { return "Unknown" }
        let kg = Double(weight) / 10.0
        let lbs = kg * 2.205
        return "\(String(format: "%.1f", lbs)) lbs (\(String(format: "%.1f", kg)) kg)"
    }
    
    private func formatAbilities(_ abilities: [PokemonAbilities]?) -> String {
        guard let abilities = abilities else { return "Unknown" }
        return abilities.compactMap { $0.ability.name?.capitalized }.joined(separator: ", ")
    }
}
