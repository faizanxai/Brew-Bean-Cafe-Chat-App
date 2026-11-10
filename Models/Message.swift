//
//  Message.swift
//  BrewBeanChatApp
//
//  Created by Faizan Nabi on 11/11/2026.
//

import Foundation
import SwiftData

@Model
final class Message {
    var id: UUID
    var content: String
    var timestamp: Date
    var senderName: String
    var chat: Chat?

    init(id: UUID = UUID(), content: String, timestamp: Date = .now, senderName: String) {
        self.id = id
        self.content = content
        self.timestamp = timestamp
        self.senderName = senderName
    }
}
