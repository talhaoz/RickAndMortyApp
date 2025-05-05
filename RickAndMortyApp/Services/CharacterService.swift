//
//  APIError.swift
//  RickAndMortyApp
//
//  Created by Talha Öz on 05/05/2025.
//
import Foundation

enum APIError: Error {
    case invalidURL
    case requestFailed
    case decodingFailed
}

struct CharacterService {
    static func fetchCharacters(page: Int) async throws -> CharacterResponse {
        guard let url = URL(string: "https://rickandmortyapi.com/api/character?page=\(page)") else {
            throw APIError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)
        guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
            throw APIError.requestFailed
        }

        do {
            let decoded = try JSONDecoder().decode(CharacterResponse.self, from: data)
            return decoded
        } catch {
            throw APIError.decodingFailed
        }
    }
}

