//
//  Persistence.swift
//  RickAndMortyApp
//
//  Created by Talha Öz on 05/05/2025.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    @MainActor
    static let preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext

        for i in 1...10 {
            let character = CharacterEntity(context: viewContext)
            character.id = Int64(i)
            character.name = "Karakter \(i)"
            character.status = (i % 2 == 0) ? "Alive" : "Dead"
            character.species = (i % 3 == 0) ? "Alien" : "Human"
            character.gender = (i % 2 == 0) ? "Male" : "Female"
            character.location = "Lokasyon \(i)"
            character.image = "https://rickandmortyapi.com/api/character/avatar/\(i).jpeg"
            character.isFavorite = (i % 3 == 0) // bazıları favori
            character.descriptionText = "Bu karakter \(i) için açıklamadır."
        }

        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Preview save error: \(nsError), \(nsError.userInfo)")
        }

        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "RickAndMortyApp")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
