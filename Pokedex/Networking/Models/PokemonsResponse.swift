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

struct PokemonEntry: Codable, Identifiable {
    var name: String
    var url: String
    var id: Int {
        let components = url.components(separatedBy: "/")
        return Int(components.dropLast().last ?? "0") ?? 0
    }
}
