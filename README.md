# Brew & Bean Cafe Chat App ☕️

An offline-first iOS chat application built with SwiftUI and SwiftData, designed for Brew & Bean Cafe customers. 

This repository contains the foundation for the app: the architecture setup, the persistence layer, and basic data models as part of **Task 1**.

---

### Architecture

For Task 1, I opted for a lightweight, native SwiftUI architecture. Since the app currently only requires local persistence and simple navigation, I intentionally avoided over-engineering with a Coordinator or heavy ViewModel layers. 

Instead, the app leans directly into Apple's modern SwiftData boilerplate:
*   **Views** handle the UI and use standard `@Query` wrappers to automatically fetch and react to data changes.
*   **Navigation** uses native SwiftUI `NavigationStack` and `NavigationLink(value:)`.
*   **Persistence** is handled directly in the View using `@Environment(\.modelContext)`.

*Note: As we introduce network requests and offline syncing in later tasks, we will extract business logic out of the View and into dedicated ViewModels and Services.*
<img width="1141" height="1381" alt="image" src="https://github.com/user-attachments/assets/00cfea08-b75e-435e-b650-5e0e8f010b92" />
## Task 2: Authentication & User Profile

- **Local Auth Flow:** Users can sign up and sign in using an email and password.
- **Security:** Passwords are hashed using `CryptoKit` (SHA256) before being stored. They are securely saved in the iOS **Keychain** using the `KeychainAccess` package.
- **State Management:** The `AuthViewModel` handles authentication logic.
- **Routing:** `ContentView` acts as the root router, observing `isAuthenticated` to show either `AuthView` or `ChatListView`.
- **Persistence:** Authenticated users are saved to the SwiftData database (`User` model).
