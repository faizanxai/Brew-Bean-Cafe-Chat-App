//
//  ContentView.swift
//  BrewBeanChatApp
//
//  Created by Faizan Nabi on 11/11/2026.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var context
    @Environment(AppCoordinator.self) private var coordinator
    @Query(sort: \Chat.createdAt, order: .reverse) private var chats: [Chat]

    var body: some View {
        @Bindable var coordinator = coordinator

        NavigationStack(path: $coordinator.path) {
            List {
                ForEach(chats) { chat in
                    Button {
                        coordinator.push(.chatDetail(chat.id))
                    } label: {
                        row(for: chat)
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
            .navigationDestination(for: AppRoute.self) { route in
                switch route {
                case .chatDetail(let id): Text("Chat Detail for ID: \(id)").navigationTitle("Chat")
                case .profile: Text("Profile")
                }
            }
        }
    }

    private func row(for chat: Chat) -> some View {
        HStack(spacing: 12) {
            Circle()
                .fill(.brown.gradient)
                .frame(width: 44, height: 44)
                .overlay {
                    Text(chat.title.prefix(1).uppercased())
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.white)
                }

            VStack(alignment: .leading, spacing: 2) {
                Text(chat.title).font(.headline).lineLimit(1)
                Text(chat.messages.max(by: { $0.timestamp < $1.timestamp })?.content ?? "No messages yet")
                    .font(.subheadline).foregroundStyle(.secondary).lineLimit(1)
            }

            Spacer()

            Text(chat.createdAt, style: .relative)
                .font(.caption2.weight(.medium))
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
        .foregroundStyle(.primary)
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
    ContentView()
        .environment(AppCoordinator())
        .modelContainer(for: [User.self, Chat.self, Message.self], inMemory: true)
}
