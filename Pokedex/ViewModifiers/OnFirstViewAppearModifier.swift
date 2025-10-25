//
//  OnFirstViewAppearModifier.swift
//  Pokedex
//
//  Created by Kaue de Assis Jacyntho on 25/10/25.
//

import SwiftUI

struct OnFirstViewAppearModifier: ViewModifier {
    
    @State private var didAppear: Bool = false
    let action: () -> Void
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                guard !didAppear else { return }
                didAppear = true
                action()
            }
    }
}

struct OnFirstTaskViewModifier: ViewModifier {
    
    @State private var didAppear: Bool = false
    let action: () async -> Void
    
    func body(content: Content) -> some View {
        content
            .task {
                guard !didAppear else { return }
                didAppear = true
                await action()
            }
    }
}

extension View {
    func onFirstAppear(action: @escaping () -> Void) -> some View {
        modifier(OnFirstViewAppearModifier(action: action))
    }
    
    func onFirstAppear(action: @escaping () async -> Void) -> some View {
        modifier(OnFirstTaskViewModifier(action: action))
    }
}
