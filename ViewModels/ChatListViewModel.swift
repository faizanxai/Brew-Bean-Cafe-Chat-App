//
//  ChatListViewModel.swift
//  BrewBeanChatApp
//
//  Created by Faizan Nabi on 11/11/2026.
//


import Foundation
import Observation

@MainActor
@Observable
final class ChatListViewModel {
    // Transient UI state (Task 1 needs none, but this is where it will live)
    var draftTitle: String = ""

    private let coordinator: AppCoordinator

    init(coordinator: AppCoordinator) {
        self.coordinator = coordinator
    }

    func didSelect(_ chat: Chat) {
        coordinator.push(.chatDetail(chat.id))
    }

    func didTapProfile() {
        coordinator.push(.profile)
    }
}
