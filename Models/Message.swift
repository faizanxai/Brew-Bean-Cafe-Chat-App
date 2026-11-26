//
//  Message.swift
//  BrewBeanChatApp
//
//  Created by Faizan Nabi on 11/11/2026.
//

import Foundation
import SwiftData

enum MessageStatus: String, Codable {
    case sending, sent, failed
}

@Model
final class Message {
    var id: UUID
    var content: String
    var timestamp: Date
    var senderName: String
    var statusRaw: String
    var chat: Chat?
    
    var status: MessageStatus {
        get { MessageStatus(rawValue: statusRaw) ?? .sent }
        set { statusRaw = newValue.rawValue }
    }

    init(id: UUID = UUID(), content: String, timestamp: Date = .now, senderName: String, status: MessageStatus = .sending) {
        self.id = id
        self.content = content
        self.timestamp = timestamp
        self.senderName = senderName
        self.statusRaw = status.rawValue
    }
}
