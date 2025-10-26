//
//  ImageLoaderView.swift
//  Pokedex
//
//  Created by Kaue de Assis Jacyntho on 25/10/25.
//

import SDWebImageSwiftUI
import SwiftUI

struct ImageLoaderView: View {
    
    var urlString: String?
    var resizingMode: ContentMode = .fill
    
    var body: some View {
        if let urlString {
            WebImage(url: URL(string: urlString))
                .resizable()
                .indicator(.progress)
                .aspectRatio(contentMode: resizingMode)
                .allowsTightening(false)
        } else {
            Image(systemName: "questionmark.circle.fill")
                .font(.system(size: 50))
                .foregroundColor(.white.opacity(0.8))
                .frame(width: 80, height: 80)
        }
    }
}
