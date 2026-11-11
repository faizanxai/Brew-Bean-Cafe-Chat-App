//
//  ContentView.swift
//  BrewBeanChatApp
//
//  Created by Faizan Nabi on 11/11/2026.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
       
        ChatListView()
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [User.self, Chat.self, Message.self], inMemory: true)
}
