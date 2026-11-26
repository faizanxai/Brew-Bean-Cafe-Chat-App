import Foundation

@MainActor
final class MockMessageService: MessageServiceProtocol {
    func fetchMessages(for chat: Chat) -> [Message] { [] }
    func saveMessage(_ message: Message, to chat: Chat) {}
    func updateStatus(for message: Message, to status: MessageStatus) {}
    
    func sendMessageToServer(text: String) async throws -> Message {
        return Message(content: "Instant mock reply", senderName: "Brew & Bean", status: .sent)
    }
}