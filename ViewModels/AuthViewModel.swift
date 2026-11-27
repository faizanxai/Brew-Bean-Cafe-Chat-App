//
//  AuthViewModel.swift
//  BrewBeanChatApp
//
//  Created by Faizan on 27/11/2026.
//


import Foundation
import SwiftUI
import SwiftData
import KeychainAccess
import CryptoKit

@MainActor
@Observable
final class AuthViewModel {
    var email = ""
    var password = ""
    var isAuthenticated = false
    var isRegistering = false
    var errorMessage: String?
    
    private let keychain = Keychain(service: "com.brewbean.cafe")
    
    private func hashPassword(_ password: String) -> String {
        let inputData = Data(password.utf8)
        let hashed = SHA256.hash(data: inputData)
        return hashed.compactMap { String(format: "%02x", $0) }.joined()
    }
    
    func signUp(context: ModelContext) {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Please enter email and password."
            return
        }
        
        do {
            if try keychain.get(email) != nil {
                errorMessage = "User already exists."
                return
            }
            
            let hashedPassword = hashPassword(password)
            
            try keychain.set(hashedPassword, key: email)
            
            let newUser = User(name: email.components(separatedBy: "@").first ?? "User", email: email)
            context.insert(newUser)
            try context.save()
            
            isAuthenticated = true
            errorMessage = nil
        } catch {
            errorMessage = "Sign up failed: \(error.localizedDescription)"
        }
    }
    
    func signIn(context: ModelContext) {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Please enter email and password."
            return
        }
        
        do {
            guard let storedHash = try keychain.get(email) else {
                errorMessage = "User not found."
                return
            }
            
            let inputHash = hashPassword(password)
            guard storedHash == inputHash else {
                errorMessage = "Incorrect password."
                return
            }
            
            let descriptor = FetchDescriptor<User>(predicate: #Predicate { $0.email == email })
            let users = try context.fetch(descriptor)
            
            if users.isEmpty {
                let newUser = User(name: email.components(separatedBy: "@").first ?? "User", email: email)
                context.insert(newUser)
                try context.save()
            }
            
            isAuthenticated = true
            errorMessage = nil
        } catch {
            errorMessage = "Sign in failed: \(error.localizedDescription)"
        }
    }
    
    func signOut() {
        isAuthenticated = false
        email = ""
        password = ""
    }
}
