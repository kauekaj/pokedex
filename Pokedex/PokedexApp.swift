//
//  PokedexApp.swift
//  Pokedex
//
//  Created by Kaue de Assis Jacyntho on 25/10/25.
//

import SwiftUI

@main
struct PokedexApp: App {
    var body: some Scene {
        WindowGroup {
            PokemonListView(viewModel: PokemonViewModel(apiService: PokemonAPIService()))
        }
    }
}
