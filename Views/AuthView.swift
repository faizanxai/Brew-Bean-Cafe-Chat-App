import SwiftUI
import SwiftData

struct AuthView: View {
    @Environment(\.modelContext) private var context
    @Bindable var viewModel: AuthViewModel

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Image(systemName: "cup.and.saucer.fill")
                    .font(.system(size: 64))
                    .foregroundStyle(.brown)
                
                Text(viewModel.isRegistering ? "Create Account" : "Welcome Back")
                    .font(.title.bold())
                
                VStack(spacing: 16) {
                    TextField("Email", text: $viewModel.email)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                        .padding()
                        .background(.white.opacity(0.8), in: .rect(cornerRadius: 12))
                    
                    SecureField("Password", text: $viewModel.password)
                        .padding()
                        .background(.white.opacity(0.8), in: .rect(cornerRadius: 12))
                }
                
                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundStyle(.red)
                        .font(.caption)
                }
                
                Button(viewModel.isRegistering ? "Sign Up" : "Sign In") {
                    if viewModel.isRegistering {
                        viewModel.signUp(context: context)
                    } else {
                        viewModel.signIn(context: context)
                    }
                }
                .font(.headline)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(.brown, in: .rect(cornerRadius: 12))
                
                Button(viewModel.isRegistering ? "Already have an account? Sign In" : "Don't have an account? Sign Up") {
                    viewModel.isRegistering.toggle()
                    viewModel.errorMessage = nil
                }
                .font(.subheadline)
                .foregroundStyle(.brown)
            }
            .padding()
            .frame(maxHeight: .infinity)
            .background(Color(red: 0.98, green: 0.95, blue: 0.90))
            .ignoresSafeArea()
        }
    }
}
