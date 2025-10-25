//
//  PokemonTypeColors.swift
//  Pokedex
//
//  Created by Kaue de Assis Jacyntho on 25/10/25.
//

import SwiftUI

enum PokemonElement: String, CaseIterable {
    case grass = "grass"
    case poison = "poison"
    case fire = "fire"
    case water = "water"
    case electric = "electric"
    case psychic = "psychic"
    case ice = "ice"
    case dragon = "dragon"
    case dark = "dark"
    case fairy = "fairy"
    case fighting = "fighting"
    case flying = "flying"
    case ground = "ground"
    case rock = "rock"
    case bug = "bug"
    case ghost = "ghost"
    case steel = "steel"
    case normal = "normal"
    
    var color: Color {
        switch self {
        case .grass:
            return Color(.sRGB, red: 0.7, green: 0.9, blue: 0.7, opacity: 1.0)
        case .poison:
            return Color(.sRGB, red: 0.8, green: 0.6, blue: 0.9, opacity: 1.0)
        case .fire:
            return Color(.sRGB, red: 1.0, green: 0.7, blue: 0.6, opacity: 1.0)
        case .water:
            return Color(.sRGB, red: 0.6, green: 0.8, blue: 1.0, opacity: 1.0)
        case .electric:
            return Color(.sRGB, red: 1.0, green: 0.9, blue: 0.6, opacity: 1.0)
        case .psychic:
            return Color(.sRGB, red: 0.9, green: 0.7, blue: 0.9, opacity: 1.0)
        case .ice:
            return Color(.sRGB, red: 0.7, green: 0.9, blue: 1.0, opacity: 1.0)
        case .dragon:
            return Color(.sRGB, red: 0.7, green: 0.6, blue: 0.9, opacity: 1.0)
        case .dark:
            return Color(.sRGB, red: 0.6, green: 0.6, blue: 0.7, opacity: 1.0)
        case .fairy:
            return Color(.sRGB, red: 1.0, green: 0.8, blue: 0.9, opacity: 1.0)
        case .fighting:
            return Color(.sRGB, red: 1.0, green: 0.8, blue: 0.6, opacity: 1.0)
        case .flying:
            return Color(.sRGB, red: 0.8, green: 0.9, blue: 0.8, opacity: 1.0)
        case .ground:
            return Color(.sRGB, red: 0.9, green: 0.8, blue: 0.6, opacity: 1.0)
        case .rock:
            return Color(.sRGB, red: 0.7, green: 0.5, blue: 0.3, opacity: 1.0)
        case .bug:
            return Color(.sRGB, red: 0.7, green: 0.9, blue: 0.7, opacity: 0.8)
        case .ghost:
            return Color(.sRGB, red: 0.8, green: 0.7, blue: 0.9, opacity: 1.0)
        case .steel:
            return Color(.sRGB, red: 0.8, green: 0.8, blue: 0.9, opacity: 1.0)
        case .normal:
            return Color(.sRGB, red: 0.8, green: 0.8, blue: 0.8, opacity: 1.0)
        }
    }
}

extension PokemonElement {
    init?(from string: String) {
        self.init(rawValue: string.lowercased())
    }
}

extension Color {
    static func pokemonTypeColor(for type: String) -> Color {
        PokemonElement(from: type)?.color ?? Color(.sRGB, red: 0.8, green: 0.8, blue: 0.8, opacity: 1.0)
    }
}
