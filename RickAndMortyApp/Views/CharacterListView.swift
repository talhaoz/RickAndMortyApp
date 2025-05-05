//
//  CharacterListView.swift
//  RickAndMortyApp
//
//  Created by Talha Öz on 05/05/2025.
//

import SwiftUI
import CoreData

struct CharacterListView: View {
    @StateObject private var viewModel = CharacterListViewModel()
    @State private var isLoaded = false
    @State private var showToast = false
    
    @State private var searchText = ""
    @State private var showOnlyFavorites = false

    private var fetchRequest: FetchRequest<CharacterEntity>
    private var characters: FetchedResults<CharacterEntity> { fetchRequest.wrappedValue }

    init() {
        fetchRequest = FetchRequest<CharacterEntity>(
            sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)],
            predicate: nil,
            animation: .default
        )
    }

    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.state {
                case .idle, .loading:
                    VStack {
                        Spacer()
                        ProgressView("Loading...")
                        Spacer()
                    }

                case .empty:
                    VStack {
                        Spacer()
                        Text("No Characters found!")
                            .foregroundColor(.gray)
                        Spacer()
                    }

                case .error(let message):
                    VStack {
                        Spacer()
                        Text("There is an error:\n\(message)")
                            .multilineTextAlignment(.center)
                            .foregroundColor(.red)
                            .padding()
                        Spacer()
                    }

                case .success:
                    characterList()
                }
            }
            .navigationTitle("Characters")
            .searchable(text: $searchText, prompt: "Search name or kind")
            .toolbar {
                EditButton()
            }
            .task {
                if !isLoaded {
                    await viewModel.loadCharactersOnce()
                    isLoaded = true
                }
            }
            .overlay(
                Group {
                    if showToast {
                        Text("Character Deleted!")
                            .font(.subheadline)
                            .padding()
                            .background(.ultraThinMaterial)
                            .cornerRadius(12)
                            .transition(.opacity)
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    withAnimation {
                                        showToast = false
                                    }
                                }
                            }
                    }
                },
                alignment: .bottom
            )
            .navigationDestination(for: CharacterEntity.self) { character in
                CharacterDetailView(character: character)
            }
        }
    }
    
    @ViewBuilder
    private func characterList() -> some View {
        Toggle("Only Favorites", isOn: $showOnlyFavorites)
                .padding(.horizontal)
        List {
            ForEach(filteredCharacters) { character in
                NavigationLink(value: character) {
                    HStack {
                        AsyncImage(url: URL(string: character.image ?? "")) { image in
                            image.resizable()
                        } placeholder: {
                            Color.gray
                        }
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())

                        VStack(alignment: .leading) {
                            Text(character.name ?? "")
                                .font(.headline)
                            Text(character.species ?? "")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .onAppear {
                    Task {
                        await viewModel.loadNextPageIfNeeded(lastCharacter: character)
                    }
                }
            }
            .onDelete(perform: deleteCharacters)
        }
    }

    private func deleteCharacters(at offsets: IndexSet) {
        withAnimation {
            offsets.map { characters[$0] }.forEach { character in
                viewModel.delete(character: character)
            }
            showToast = true
        }
    }
    
    private var filteredCharacters: [CharacterEntity] {
        let trimmedSearch = searchText.trimmingCharacters(in: .whitespacesAndNewlines)

        return characters.filter { character in
            let matchesSearch =
                trimmedSearch.isEmpty ||
                (character.name?.localizedCaseInsensitiveContains(trimmedSearch) ?? false) ||
                (character.species?.localizedCaseInsensitiveContains(trimmedSearch) ?? false)

            let matchesFavorite =
                !showOnlyFavorites || character.isFavorite

            return matchesSearch && matchesFavorite
        }
    }
}

