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
    
    var body: some View {
        Group {
            if authViewModel.isAuthenticated {
                ChatListView()
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
