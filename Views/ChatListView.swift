//
//  ChatListView.swift
//  BrewBeanChatApp
//
//  Created by Faizan Nabi on 12/11/2026.
//


import SwiftUI
import SwiftData

struct ChatListView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Chat.createdAt, order: .reverse) private var chats: [Chat]

    var body: some View {
        NavigationStack {
            List {
                ForEach(chats) { chat in
                    NavigationLink(value: chat) {
                        // 👇 Use the extracted view here
                        ChatRowView(chat: chat)
                    }
                    .listRowBackground(Color.white.opacity(0.85))
                }
                .onDelete(perform: deleteChats)
            }
            .scrollContentBackground(.hidden)
            .background(Color(red: 0.98, green: 0.95, blue: 0.90))
            .navigationTitle("Brew & Bean")
            .tint(.brown)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) { EditButton() }
                ToolbarItem {
                    Button(action: addChat) { Label("New Chat", systemImage: "plus") }
                }
            }
            .overlay {
                if chats.isEmpty {
                    ContentUnavailableView(
                        "No Chats Yet",
                        systemImage: "cup.and.saucer.fill",
                        description: Text("Tap + to start a conversation")
                    )
                }
            }
            .navigationDestination(for: Chat.self) { chat in
                ChatDetailView(chat: chat)
            }
        }
    }

   

    private func addChat() {
        withAnimation {
            context.insert(Chat(title: "New Chat"))
        }
    }

    private func deleteChats(offsets: IndexSet) {
        withAnimation {
            offsets.forEach { context.delete(chats[$0]) }
        }
    }
}

#Preview {
    ChatListView()
        .modelContainer(for: [User.self, Chat.self, Message.self], inMemory: true)
}
