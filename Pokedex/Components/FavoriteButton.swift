//
//  FavoriteButton.swift
//  Pokedex
//
//  Created by Kaue de Assis Jacyntho on 25/10/25.
//

import SwiftUI

struct FavoriteButton: View {
    @Binding var isFavorite: Bool
    let font: Font
    let action: () -> Void
    
    init(isFavorite: Binding<Bool>, font: Font = .title2, action: @escaping () -> Void = {}) {
        self._isFavorite = isFavorite
        self.font = font
        self.action = action
    }
    
    var body: some View {
        Button(action: {
            isFavorite.toggle()
            action()
        }) {
            Image(systemName: isFavorite ? "heart.fill" : "heart")
                .font(font)
                .foregroundColor(.white)
        }
    }
}
