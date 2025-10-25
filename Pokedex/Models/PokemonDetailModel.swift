//
//  PokemonDetailModel.swift
//  Pokedex
//
//  Created by Kaue de Assis Jacyntho on 25/10/25.
//

import Foundation

struct PokemonDetailModel {
    let pokemon: PokemonEntry
    let pokemonDetail: SelectedPokemonResponse?
    let imageURL: URL?
    
    init(pokemon: PokemonEntry, pokemonDetail: SelectedPokemonResponse?) {
        self.pokemon = pokemon
        self.pokemonDetail = pokemonDetail
        
        if let imageURL = pokemonDetail?.sprites?.other?.officialArtwork?.frontDefault {
            self.imageURL = URL(string: imageURL)
        } else {
            self.imageURL = nil
        }
    }
}
