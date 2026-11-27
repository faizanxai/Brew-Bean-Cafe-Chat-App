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
## Task 3: Messaging Core with Offline Sync

- **Messaging Engine:** Built a `ChatViewModel` using MVVM that handles the messaging logic. The UI (`ChatDetailView`) is completely decoupled from the data layer.
- **Protocol-Oriented Architecture:** Created a `MessageServiceProtocol` to abstract the data source. The `MockMessageService` implements this protocol to handle local SwiftData saves and simulate a backend server.
- **Optimistic UI Updates:** When a user sends a message, it is instantly saved to SwiftData with a `.sending` status, making the UI update immediately. Once the server responds, the status updates to `.sent`.
- **Simulated Server:** The service uses `Task.sleep(for: .seconds(1))` to simulate a 1-second network delay, then reads a random response from a local `mock_replies.json` file to simulate the cafe replying.
- **Offline Detection:** Implemented `NWPathMonitor` to continuously check internet connectivity. If the user is offline, a red banner appears, and sent messages are instantly marked as `.failed`.
- **Persistence:** Messages are saved to the local SwiftData database and automatically re-populate the chat screen when the app is relaunched.
