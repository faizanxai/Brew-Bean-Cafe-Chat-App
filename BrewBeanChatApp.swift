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
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [User.self, Chat.self, Message.self])
    }
}
