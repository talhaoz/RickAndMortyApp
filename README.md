🌀 Rick and Morty SwiftUI App

An iOS app built using SwiftUI, Combine, and Core Data, displaying characters from the Rick and Morty API. This project demonstrates real-world architecture practices, including:

- Asynchronous networking

- Persistent local storage

- Pagination support

- Filtering and searching

- UI state management (loading, error, empty states)


📱 Features

✅ Browse Rick and Morty characters with detailed views

✅ Persistent local storage using Core Data

✅ Add/remove characters as favorites (with heart icon)

✅ Search by name or species

✅ Filter to show only favorite characters

✅ Infinite scroll with API-based pagination


🛠 Technologies

- SwiftUI

- Combine

- Core Data

- MVVM

- Async/Await

- Rick and Morty API

- iOS 16+ compatibility

🧩 Architecture Overview
Model: Character, CharacterResponse, CharacterEntity (Core Data)

ViewModel: CharacterListViewModel handles pagination, search, and loading logic

Service Layer: CharacterService handles API interactions

Persistence Layer: PersistenceService manages Core Data save/load

▶️ Demo

https://github.com/user-attachments/assets/5041deba-655b-4e7a-9774-5fade7e22ec3




