//
//  SelectedPokemonResponse.swift
//  Pokedex
//
//  Created by Kaue de Assis Jacyntho on 25/10/25.
//

import Foundation

struct SelectedPokemonResponse: Codable {
    var sprites: PokemonSprites?
    var name: String?
    var id: Int?
    var weight: Int?
    var height: Int?
    var moves: [PokemonMoves]?
    var types: [PokemonType]?
    var stats: [PokemonStats]?
    var abilities: [PokemonAbilities]?
}

struct PokemonSprites: Codable {
    var frontDefault: String?
    var other: Other?
}

struct Other: Codable {
    var home: Home
    var officialArtwork: OfficialArtwork?
    
    
    enum CodingKeys: String, CodingKey {
        case home = "home"
        case officialArtwork = "official-artwork"
    }
}

struct Home: Codable {
    var frontDefault: String?
}

struct OfficialArtwork: Codable {
    var frontDefault: String?
}

struct PokemonMoves: Codable {
    var move: PokeMove
}

struct PokeMove: Codable {
    var name: String?
    var url: String?
}

struct PokemonType: Codable {
    var type: PokeType
}

struct PokeType: Codable {
    var name: String?
    var url: String?
}

struct PokemonStats: Codable {
    var baseStat: Int?
    var stat: PokeStat
}

struct PokeStat: Codable {
    var name: String?
    var url: String?
}
struct PokemonAbilities: Codable {
    var ability: PokeAbility
}

struct PokeAbility: Codable {
    var name: String?
    var url: String?
}

// MARK: - Extensions for SelectedPokemonResponse
extension SelectedPokemonResponse {
    var allTypes: [String] {
        return types?.compactMap { $0.type.name } ?? []
    }
    
    var primaryType: String? {
        return types?.first?.type.name
    }
}
