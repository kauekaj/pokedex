//
//  BaseStatsTabView.swift
//  Pokedex
//
//  Created by Kaue de Assis Jacyntho on 25/10/25.
//

import SwiftUI

struct BaseStatsTabView: View {
    let pokemonDetail: SelectedPokemonResponse?
    
    private var statColor: Color {
        guard let primaryType = pokemonDetail?.primaryType else {
            return .blue
        }
        return Color.pokemonTypeColor(for: primaryType)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if let stats = pokemonDetail?.stats {
                ForEach(stats, id: \.stat.name) { stat in
                    StatRow(
                        name: formatStatName(stat.stat.name),
                        value: stat.baseStat ?? 0,
                        maxValue: 100,
                        color: statColor
                    )
                }
                
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 20)
    }
    
    private func formatStatName(_ name: String?) -> String {
        guard let name = name else { return "Unknown" }
        switch name {
        case "hp": return "HP"
        case "attack": return "Attack"
        case "defense": return "Defense"
        case "special-attack": return "Sp. Atk"
        case "special-defense": return "Sp. Def"
        case "speed": return "Speed"
        default: return name.capitalized
        }
    }
}
