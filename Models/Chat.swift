//
//  Chat.swift
//  BrewBeanChatApp
//
//  Created by Faizan Nabi on 11/11/2026.
//


import Foundation
import SwiftData

@Model
final class Chat {
    var id: UUID
    var title: String
    var createdAt: Date

   
    @Relationship(deleteRule: .cascade, inverse: \Message.chat)
    var messages: [Message] = []

    init(id: UUID = UUID(), title: String, createdAt: Date = .now) {
        self.id = id
        self.title = title
        self.createdAt = createdAt
    }
}
