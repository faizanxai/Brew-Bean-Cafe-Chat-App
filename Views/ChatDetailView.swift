//
//  ChatDetailView.swift
//  BrewBeanChatApp
//
//  Created by Faizan Nabi on 11/11/2026.
//


import SwiftUI

struct ChatDetailView: View {
    let chat: Chat

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "bubble.left.and.bubble.right.fill")
                .font(.system(size: 48))
                .foregroundStyle(.brown.opacity(0.5))
            
            Text(chat.title)
                .font(.title2.bold())
            
            Text("Messaging UI arrives in Task 3.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .navigationTitle(chat.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}
