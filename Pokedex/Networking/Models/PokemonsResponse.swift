//
//  PokemonsResponse.swift
//  Pokedex
//
//  Created by Kaue de Assis Jacyntho on 25/10/25.
//

import Foundation

struct PokemonsResponse : Codable {
    var results: [PokemonEntry]
}

struct PokemonEntry: Codable {
    var name: String
    var url: String
}
