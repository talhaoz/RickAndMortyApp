//
//  CharacterDetailView.swift
//  RickAndMortyApp
//
//  Created by Talha Öz on 05/05/2025.
//


import SwiftUI

struct CharacterDetailView: View {
    @ObservedObject var character: CharacterEntity
    @Environment(\.managedObjectContext) private var context
    @State private var showSavedToast = false
    
    @State private var descriptionInput: String = ""


    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                AsyncImage(url: URL(string: character.image ?? "")) { image in
                    image.resizable()
                } placeholder: {
                    Color.gray
                }
                .frame(width: 200, height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 20))

                Text(character.name ?? "")
                    .font(.title)
                    .bold()

                Text("Status: \(character.status ?? "-")")
                Text("Kind: \(character.species ?? "-")")
                Text("Gender: \(character.gender ?? "-")")
                Text("Location: \(character.location ?? "-")")
                
                
                Divider()

                VStack(alignment: .leading, spacing: 8) {
                    Text("Description:")
                        .font(.headline)

                    TextEditor(text: $descriptionInput)
                    .frame(minHeight: 100)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3)))

                    HStack {
                            Spacer()
                            Button("Save") {
                                saveDescription()
                            }
                            .buttonStyle(.borderedProminent)
                            .padding()
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Detail")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    toggleFavorite()
                } label: {
                    Image(systemName: character.isFavorite ? "heart.fill" : "heart")
                }
            }
        }
        .overlay(
            Group {
                if showSavedToast {
                    Text("Açıklama kaydedildi")
                        .padding(8)
                        .background(.ultraThinMaterial)
                        .cornerRadius(12)
                        .transition(.opacity)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation {
                                    showSavedToast = false
                                }
                            }
                        }
                }
            },
            alignment: .bottom
        )
        .onAppear {
            descriptionInput = character.descriptionText ?? ""
        }
    }
    
    private func saveDescription() {
        character.descriptionText = descriptionInput
            do {
                try context.save()
                withAnimation {
                    showSavedToast = true
                }
            } catch {
                print("Açıklama kaydedilemedi: \(error.localizedDescription)")
            }
    }
    
    private func toggleFavorite() {
        character.isFavorite.toggle()
        do {
            try context.save()
        } catch {
            print("Favori güncellenemedi: \(error.localizedDescription)")
        }
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    let character = CharacterEntity(context: context)

    return CharacterDetailView(character: character)
}
