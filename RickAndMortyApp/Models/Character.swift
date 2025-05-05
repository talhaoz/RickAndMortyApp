//
//  Character.swift
//  RickAndMortyApp
//
//  Created by Talha Öz on 05/05/2025.
//


struct CharacterResponse: Codable {
    let info: Info
    let results: [Character]

    struct Info: Codable {
        let next: String?
        let pages: Int
        let count: Int
    }
}

struct Character: Codable, Identifiable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let gender: String
    let image: String
    let location: Location

    struct Location: Codable {
        let name: String
    }
}

