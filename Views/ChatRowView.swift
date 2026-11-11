//
//  ChatRowView.swift
//  BrewBeanChatApp
//
//  Created by Faizan Nabi on 12/11/2026.
//

import SwiftUI

struct ChatRowView: View {
    let chat: Chat

    var body: some View {
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
}
