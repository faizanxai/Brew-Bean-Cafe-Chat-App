import SwiftUI
import SwiftData

struct ChatDetailView: View {
    @Environment(\.modelContext) private var context
    @State private var viewModel: ChatViewModel
    @Query private var messages: [Message]
    
    let currentUser = "Faizan"
    
    init(chat: Chat, context: ModelContext, networkMonitor: NetworkMonitor) {
        let Service = MockMessageService(context: context)
        
        _viewModel = State(initialValue: ChatViewModel(chat: chat, messageService: Service, networkMonitor: networkMonitor))
        
        let chatID = chat.id
        _messages = Query(filter: #Predicate<Message> { $0.chat?.id == chatID }, sort: \.timestamp)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            if !viewModel.networkMonitor.isConnected {
                Text("Offline Mode - Messages will fail to send")
                    .font(.caption)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(6)
                    .background(.red.opacity(0.8))
            }
            
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(messages) { message in
                            messageBubble(for: message)
                                .id(message.id)
                        }
                    }
                    .padding()
                }
                .onChange(of: messages.count) {
                    if let last = messages.last {
                        withAnimation { proxy.scrollTo(last.id, anchor: .bottom) }
                    }
                }
            }
            
            HStack(spacing: 12) {
                TextField("Message...", text: $viewModel.messageText)
                    .padding(12)
                    .background(Color.white, in: .rect(cornerRadius: 20))
                    .overlay(RoundedRectangle(cornerRadius: 20).stroke(.brown.opacity(0.3)))
                
                Button(action: viewModel.sendMessage) {
                    Image(systemName: "paperplane.fill")
                        .foregroundStyle(.white)
                        .padding(12)
                        .background(.brown, in: Circle())
                }
                .disabled(viewModel.messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            .padding()
            .background(Color(red: 0.98, green: 0.95, blue: 0.90).shadow(.drop(radius: 2, y: -2)))
        }
        .navigationTitle(viewModel.chat.title)
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(red: 0.98, green: 0.95, blue: 0.90))
    }
    
    private func messageBubble(for message: Message) -> some View {
        let isMe = message.senderName == currentUser
        
        return HStack {
            if isMe { Spacer() }
            
            VStack(alignment: isMe ? .trailing : .leading, spacing: 4) {
                Text(message.content)
                    .padding(12)
                    .background(isMe ? .brown : Color.white)
                    .foregroundStyle(isMe ? .white : .primary)
                    .clipShape(.rect(cornerRadius: 16))
                
                HStack(spacing: 4) {
                    Text(message.timestamp, style: .time)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                    
                    if isMe {
                        statusIcon(for: message.status)
                    }
                }
            }
            
            if !isMe { Spacer() }
        }
    }
    
    @ViewBuilder
    private func statusIcon(for status: MessageStatus) -> some View {
        switch status {
        case .sending: Image(systemName: "clock").font(.caption2).foregroundStyle(.secondary)
        case .sent: Image(systemName: "checkmark").font(.caption2).foregroundStyle(.blue)
        case .failed: Image(systemName: "exclamationmark.circle").font(.caption2).foregroundStyle(.red)
        }
    }
}
