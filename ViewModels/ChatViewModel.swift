//
//  ChatViewModel.swift
//  BrewBeanChatApp
//
//  Created by Faizan Nabi on 26/11/2026.
//


import Foundation
import SwiftData
import Observation

@MainActor
@Observable
final class ChatViewModel {
    var messageText = ""
    
    private let chat: Chat
    private let messageService: MessageServiceProtocol
    private let networkMonitor: NetworkMonitor
    private let currentUser = "Faizan" // In a real app, get this from Auth
    
    init(chat: Chat, messageService: MessageServiceProtocol, networkMonitor: NetworkMonitor) {
        self.chat = chat
        self.messageService = messageService
        self.networkMonitor = networkMonitor
    }
    
    func sendMessage() {
        let text = messageText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }
        
        messageText = ""
        
        // 1. OPTIMISTIC UI: Create locally immediately with .sending status
        let newMessage = Message(content: text, senderName: currentUser, status: .sending)
        messageService.saveMessage(newMessage, to: chat)
        
        // 2. Check Network
        guard networkMonitor.isConnected else {
            messageService.updateStatus(for: newMessage, to: .failed)
            return
        }
        
        // 3. Hit the server asynchronously
        Task {
            do {
                let serverReply = try await messageService.sendMessageToServer(text: text)
                
                // Mark original as sent
                messageService.updateStatus(for: newMessage, to: .sent)
                
                // Save the server's reply
                messageService.saveMessage(serverReply, to: chat)
            } catch {
                messageService.updateStatus(for: newMessage, to: .failed)
            }
        }
    }
}