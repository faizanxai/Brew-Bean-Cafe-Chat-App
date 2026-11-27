//
//  MessageService.swift
//  BrewBeanChatApp
//
//  Created by Faizan Nabi on 26/11/2026.
//

import Foundation

protocol MessageService: Sendable {
    func fetchMessages(for chat: Chat) -> [Message]
    func saveMessage(_ message: Message, to chat: Chat)
    func updateStatus(for message: Message, to status: MessageStatus)
    func sendMessageToServer(text: String) async throws -> Message
}
