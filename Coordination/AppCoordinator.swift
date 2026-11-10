//
//  AppCoordinator.swift
//  BrewBeanChatApp
//
//  Created by Faizan Nabi on 11/11/2026.
//


import SwiftUI
import Observation

/// Owns all navigation state. Views call this via @Environment.
@Observable
final class AppCoordinator {
    var path = NavigationPath()

    func push(_ route: AppRoute) { path.append(route) }
    func pop() { if !path.isEmpty { path.removeLast() } }
    func popToRoot() { path.removeLast(path.count) }
}
