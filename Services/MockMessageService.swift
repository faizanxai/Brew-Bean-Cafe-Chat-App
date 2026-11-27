import Foundation
import SwiftData

@MainActor
final class MockMessageService: MessageService {
    private let context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    func fetchMessages(for chat: Chat) -> [Message] {
        return chat.messages.sorted { $0.timestamp < $1.timestamp }
    }
    
    func saveMessage(_ message: Message, to chat: Chat) {
        message.chat = chat
        chat.messages.append(message)
        context.insert(message)
        try? context.save()
    }
    
    func updateStatus(for message: Message, to status: MessageStatus) {
        message.status = status
        try? context.save()
    }
    
    func sendMessageToServer(text: String) async throws -> Message {
        try await Task.sleep(for: .seconds(1))
        
        guard let url = Bundle.main.url(forResource: "mock_replies", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let replies = try? JSONDecoder().decode([String].self, from: data),
              let randomReply = replies.randomElement() else {
            throw URLError(.badServerResponse)
        }
        
        return Message(
            content: randomReply,
            senderName: "Brew & Bean",
            status: .sent
        )
    }
}
