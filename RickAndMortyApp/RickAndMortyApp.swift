//
//  RickAndMortyAppApp.swift
//  RickAndMortyApp
//
//  Created by Talha Öz on 05/05/2025.
//

import SwiftUI

@main
struct RickMortyApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

