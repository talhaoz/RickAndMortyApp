//
//  CharacterListViewModel.swift
//  RickAndMortyApp
//
//  Created by Talha Öz on 05/05/2025.
//


import Foundation
import CoreData

@MainActor
class CharacterListViewModel: ObservableObject {
    @Published var state: ViewState = .idle

    private let context = PersistenceController.shared.container.viewContext
    private let persistence = PersistenceService()

    private var currentPage = 1
    private var isLoadingNextPage = false
    private var hasMorePages = true
    
    func loadCharactersOnce() async {
        guard !UserDefaults.standard.bool(forKey: "hasLoadedCharacters") else {
            state = .success
            return
        }

        state = .loading

        do {
            let response = try await CharacterService.fetchCharacters(page: 1)
            try persistence.saveCharacters(response.results)
            currentPage = 1
            hasMorePages = response.info.next != nil
            UserDefaults.standard.set(true, forKey: "hasLoadedCharacters")
            state = .success
        } catch {
            state = .error(error.localizedDescription)
        }
    }

    func loadNextPageIfNeeded(lastCharacter: CharacterEntity) async {
        guard !isLoadingNextPage && hasMorePages else { return }

        let characters = try? context.fetch(CharacterEntity.fetchRequest())
        guard let list = characters as? [CharacterEntity],
              let last = list.last,
              last.id == lastCharacter.id else { return }

        isLoadingNextPage = true

        do {
            let nextPage = currentPage + 1
            let response = try await CharacterService.fetchCharacters(page: nextPage)
            try persistence.saveCharacters(response.results)
            currentPage = nextPage
            hasMorePages = response.info.next != nil
        } catch {
            print("Can't load the page: \(error.localizedDescription)")
        }

        isLoadingNextPage = false
    }
    
    func delete(character: CharacterEntity) {
        context.delete(character)
        try? context.save()
    }
}




