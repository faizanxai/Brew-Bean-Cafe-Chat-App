//
//  ChatListView.swift
//  BrewBeanChatApp
//
//  Created by Faizan Nabi on 11/11/2026.
//

import SwiftUI
import SwiftData

struct ChatListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Chat.createdAt, order: .reverse) private var chats: [Chat]
    @State private var viewModel: ChatListViewModel

    init(viewModel: ChatListViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        List {
            ForEach(chats) { chat in
                Button {
                    viewModel.didSelect(chat)   // ← nav goes through VM → Coordinator
                } label: {
                    VStack(alignment: .leading) {
                        Text(chat.title).font(.headline)
                        Text("\(chat.messages.count) messages")
                            .font(.caption).foregroundStyle(.secondary)
                    }
                }
            }
            .onDelete(perform: deleteChats)
        }
        .navigationTitle("Brew & Bean")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: addChat) {
                    Label("New Chat", systemImage: "plus")
                }
            }
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    viewModel.didTapProfile()
                } label: {
                    Image(systemName: "person.circle")
                }
            }
        }
    }

    // MARK: - CRUD (inline, like Xcode template)
    private func addChat() {
        withAnimation {
            let chat = Chat(title: "New Chat")
            modelContext.insert(chat)
        }
    }

    private func deleteChats(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(chats[index]) // cascade removes messages
            }
        }
    }
}

#Preview {
    ChatListView(viewModel:
        ChatListViewModel(coordinator:
            AppCoordinator()
        )
    )
}
