//
//  PokemonAPIService.swift
//  Pokedex
//
//  Created by Kaue de Assis Jacyntho on 25/10/25.
//

import Foundation

protocol PokemonAPIServiceProtocol {
    func getData() async throws -> [PokemonEntry]
    func getPokemonDetails(name: String) async throws -> SelectedPokemonResponse
}

class PokemonAPIService: PokemonAPIServiceProtocol {
    
    var jsonDecoder: JSONDecoder {
        let element = JSONDecoder()
        element.keyDecodingStrategy = .convertFromSnakeCase
        return element
    }
    
    func getData() async throws -> [PokemonEntry] {
        var url = URLComponents(string: "https://pokeapi.co/api/v2/pokemon")
        let queryItem = URLQueryItem(name: "limit", value: "151")
        url?.queryItems = [queryItem]
        
        guard let url = url?.url else {
            throw APIError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw APIError.invalidResponse
        }
        
        let pokemonList = try jsonDecoder.decode(PokemonsResponse.self, from: data)
        return pokemonList.results
    }
    
    func getPokemonDetails(name: String) async throws -> SelectedPokemonResponse {
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(name)") else {
            throw APIError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw APIError.invalidResponse
        }
        
        let pokemonDetails = try jsonDecoder.decode(SelectedPokemonResponse.self, from: data)
        return pokemonDetails
    }
}

enum APIError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from server"
        }
    }
}
