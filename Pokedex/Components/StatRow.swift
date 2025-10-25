//
//  StatRow.swift
//  Pokedex
//
//  Created by Kaue de Assis Jacyntho on 25/10/25.
//

import SwiftUI

struct StatRow: View {
    let name: String
    let value: Int
    let maxValue: Int
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(name)
                    .fontWeight(.medium)
                Spacer()
                Text("\(value)")
                    .fontWeight(.semibold)
            }
            
            ProgressView(value: Double(value), total: Double(maxValue))
                .progressViewStyle(LinearProgressViewStyle(tint: color))
        }
    }
}
