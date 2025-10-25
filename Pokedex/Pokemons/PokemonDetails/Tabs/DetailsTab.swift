//
//  DetailTab.swift
//  Pokedex
//
//  Created by Kaue de Assis Jacyntho on 25/10/25.
//

import Foundation

enum DetailsTab: CaseIterable {
    case about, baseStats
    
    var title: String {
        switch self {
        case .about: return "About"
        case .baseStats: return "Base Stats"
        }
    }
}
