//
//  ContentView.swift
//  BrewBeanChatApp
//
//  Created by Faizan Nabi on 11/11/2026.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var authViewModel = AuthViewModel()
    @State private var networkMonitor = NetworkMonitor() // Create monitor here
    
    var body: some View {
        Group {
            if authViewModel.isAuthenticated {
                // Pass it to ChatListView
                ChatListView(networkMonitor: networkMonitor)
            } else {
                AuthView(viewModel: authViewModel)
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [User.self, Chat.self, Message.self], inMemory: true)
}
