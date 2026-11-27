//
//  ChatViewModel.swift
//  BrewBeanChatApp
//
//  Created by Faizan on 27/11/2026.
//


import Foundation
import SwiftData
import Observation

@MainActor
@Observable
final class ChatViewModel {
    var messageText = ""
    
     let chat: Chat
     let networkMonitor: NetworkMonitor
    
    private let messageService: MessageService
    private let currentUser = "Faizan"
    
    init(chat: Chat, messageService: MessageService, networkMonitor: NetworkMonitor) {
        self.chat = chat
        self.messageService = messageService
        self.networkMonitor = networkMonitor
    }
    
    func sendMessage() {
        let text = messageText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }
        
        messageText = ""
        
        let newMessage = Message(content: text, senderName: currentUser, status: .sending)
        messageService.saveMessage(newMessage, to: chat)
        
        guard networkMonitor.isConnected else {
            messageService.updateStatus(for: newMessage, to: .failed)
            return
        }
        
        Task {
            do {
                let serverReply = try await messageService.sendMessageToServer(text: text)
                
                messageService.updateStatus(for: newMessage, to: .sent)
                
                messageService.saveMessage(serverReply, to: chat)
            } catch {
                messageService.updateStatus(for: newMessage, to: .failed)
            }
        }
    }
}
