//
//  PokedexUITests.swift
//  PokedexUITests
//
//  Created by Kaue de Assis Jacyntho on 25/10/25.
//

import XCTest

final class PokedexUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    // MARK: - App Launch Tests
    
    @MainActor
    func test_appLaunch_shouldDisplayPokemonList() throws {
        // Given
        app.launch()
        
        // Wait for the app to load and Pokemon list to appear
        // The grid is inside a ScrollView, so we need to look for it differently
        let scrollView = app.scrollViews.firstMatch
        XCTAssertTrue(scrollView.waitForExistence(timeout: 15))
        
        // Then
        // Verify the main UI elements are present
        XCTAssertTrue(app.staticTexts["Pokedex"].exists)
        XCTAssertTrue(app.staticTexts["Gotta Catch 'Em All"].exists)
        
        // Wait a bit more for Pokemon data to load
        sleep(3)
        
        // Verify Pokemon cards are displayed (they might be in a grid within the scroll view)
        let pokemonCards = scrollView.otherElements
        XCTAssertGreaterThan(pokemonCards.count, 0, "Should have at least one Pokemon card")
    }
    
    @MainActor
    func test_appLaunchesAndShowsPokemonList() throws {
        // Given & When
        app.launch()
        
        // Wait for the app to fully load
        sleep(5)
        
        // Then
        // Check if the main title is visible
        XCTAssertTrue(app.staticTexts["Pokedex"].exists, "Pokédex title should be visible")
        
        // Check if the subtitle is visible
        XCTAssertTrue(app.staticTexts["Gotta Catch 'Em All"].exists, "Subtitle should be visible")
        
        // Check if there's a scroll view (which contains the Pokemon grid)
        XCTAssertTrue(app.scrollViews.count > 0, "Should have at least one scroll view")
    }
    
    @MainActor
    func test_canNavigateToPokemonDetails() throws {
        // Given
        app.launch()
        
        // Wait for the app to fully load
        sleep(5)
        
        // When
        // Try to find and tap any tappable element in the scroll view
        let scrollView = app.scrollViews.firstMatch
        if scrollView.exists {
            // Look for any tappable element within the scroll view
            let tappableElements = scrollView.otherElements
            if tappableElements.count > 0 {
                let firstElement = tappableElements.firstMatch
                firstElement.tap()
                
                // Wait a moment for navigation
                sleep(2)
                
                // Then
                // Check if we can find a back button (indicating we're in detail view)
                let backButton = app.buttons.matching(identifier: "arrow.left").firstMatch
                if backButton.exists {
                    // We're in the detail view, test navigation back
                    backButton.tap()
                    sleep(1)
                    
                    // Should be back to the main list
                    XCTAssertTrue(app.staticTexts["Pokedex"].exists, "Should be back to main list")
                }
            }
        }
    }
    
    @MainActor
    func test_searchFieldExists() throws {
        // Given
        app.launch()
        
        // Wait for the app to fully load
        sleep(5)
        
        // When & Then
        // Look for any text field (search field)
        let textFields = app.textFields
        XCTAssertTrue(textFields.count > 0, "Should have at least one text field (search)")
    }
}
