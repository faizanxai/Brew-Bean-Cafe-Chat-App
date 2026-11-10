//
//  BrewBeanChatAppApp.swift
//  BrewBeanChatApp
//
//  Created by Faizan Nabi on 11/11/2026.
//
import SwiftUI
import SwiftData

@main
struct BrewBeanChatApp: App {
    @State private var coordinator = AppCoordinator()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(coordinator)
        }
        .modelContainer(for: [User.self, Chat.self, Message.self])
    }
}
