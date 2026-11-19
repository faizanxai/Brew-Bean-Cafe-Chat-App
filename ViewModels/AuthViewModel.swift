//
//  AuthViewModel.swift
//  BrewBeanChatApp
//
//  Created by Faizan Nabi on 19/11/2026.
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
    
    // SHA256 Hashing function
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
            // Check if user already exists in Keychain
            if try keychain.get(email) != nil {
                errorMessage = "User already exists."
                return
            }
            
            let hashedPassword = hashPassword(password)
            
            // 1. Save to Keychain
            try keychain.set(hashedPassword, key: email)
            
            // 2. Save to SwiftData
            let newUser = User(name: email.components(separatedBy: "@").first ?? "User", email: email)
            context.insert(newUser)
            try context.save()
            
            // 3. Update state
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
            // 1. Get hashed password from Keychain
            guard let storedHash = try keychain.get(email) else {
                errorMessage = "User not found."
                return
            }
            
            // 2. Hash the input password and compare
            let inputHash = hashPassword(password)
            guard storedHash == inputHash else {
                errorMessage = "Incorrect password."
                return
            }
            
            // 3. Check if user exists in SwiftData (optional, but good for session)
            let descriptor = FetchDescriptor<User>(predicate: #Predicate { $0.email == email })
            let users = try context.fetch(descriptor)
            
            // If user doesn't exist in SwiftData for some reason, recreate them
            if users.isEmpty {
                let newUser = User(name: email.components(separatedBy: "@").first ?? "User", email: email)
                context.insert(newUser)
                try context.save()
            }
            
            // 4. Update state
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
