//
//  PersistenceService.swift
//  RickAndMortyApp
//
//  Created by Talha Öz on 05/05/2025.
//


import CoreData

struct PersistenceService {
    let context = PersistenceController.shared.container.viewContext
    
    func saveCharacters(_ characters: [Character]) throws {
        for c in characters {
            let fetchRequest: NSFetchRequest<CharacterEntity> = CharacterEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %d", c.id)
            fetchRequest.fetchLimit = 1

            let exists = try context.fetch(fetchRequest).first

            // Zaten varsa hiç dokunma
            guard exists == nil else { continue }

            // Yoksa ekle
            let entity = CharacterEntity(context: context)
            entity.id = Int64(c.id)
            entity.name = c.name
            entity.status = c.status
            entity.species = c.species
            entity.gender = c.gender
            entity.image = c.image
            entity.location = c.location.name
        }

        try context.save()
    }
}
