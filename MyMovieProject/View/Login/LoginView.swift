import SwiftUI

struct LoginView: View {
    @ObservedObject private var vm = LoginViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                
                TextField("Email...", text: $vm.email)
                    .padding()
                    .background(Color.gray.opacity(0.3))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.horizontal)
                    .padding(.top)
                
                SecureField("Password...", text: $vm.password)
                    .padding()
                    .background(Color.gray.opacity(0.3))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.horizontal)
                
                Button {
                    vm.loginUser()
                } label: {
                    Text("Log in")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 55)
                        .background(Color.accentColor)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding()
                }
                NavigationLink ("Create an account") {
                    SignInView()
                        .navigationBarBackButtonHidden()
                }
                
                Spacer()
                
            }
            .navigationTitle("Login")
            .fullScreenCover(isPresented: $vm.goHome) {
                HomeView()
            }
            .alert("Não foi possível fazer o login", isPresented: $vm.showAlertLoginFailed) {}
            .overlay(content: {
                if vm.waitingProcess {
                    ProgressView("authenticating...")
                }
            })
        }
    }
}

#Preview {
    NavigationStack {
        LoginView()
    }
}
