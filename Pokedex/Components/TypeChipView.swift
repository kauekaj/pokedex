//
//  TypeChipView.swift
//  Pokedex
//
//  Created by Kaue de Assis Jacyntho on 25/10/25.
//

import SwiftUI

struct TypeChipView: View {
    let type: String
    
    var body: some View {
        Text(type)
            .font(.caption)
            .fontWeight(.medium)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color.white.opacity(0.2))
            .foregroundColor(.white)
            .cornerRadius(8)
    }
}
