//
//  User.swift
//  BrewBeanChatApp
//
//  Created by Faizan Nabi on 11/11/2026.
//


import Foundation
import SwiftData

@Model
final class User {
    var id: UUID
    var name: String
    var avatarURL: String?

    init(id: UUID = UUID(), name: String, avatarURL: String? = nil) {
        self.id = id
        self.name = name
        self.avatarURL = avatarURL
    }
}
