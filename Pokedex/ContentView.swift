//
//  ContentView.swift
//  Pokedex
//
//  Created by Kaue de Assis Jacyntho on 25/10/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        PokemonListView(viewModel: PokemonViewModel())
    }
}

#Preview {
    ContentView()
}
