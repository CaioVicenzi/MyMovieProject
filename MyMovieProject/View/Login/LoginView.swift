import SwiftUI

struct LoginView: View {
    @ObservedObject private var vm = LoginViewModel()
    @EnvironmentObject var loginStateService : LoginStateService
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 0) {
                Text("Email")
                    .font(.callout)
                    .fontWeight(.light)
                    .padding(.horizontal)
                
                TextField("Email...", text: $vm.email)
                    .padding()
                    .background(Color.gray.opacity(0.3))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.horizontal)
                    .padding(.bottom)
                
                Text("Password")
                    .font(.callout)
                    .fontWeight(.light)
                    .padding(.horizontal)
                
                SecureField("Password...", text: $vm.password)
                    .padding()
                    .background(Color.gray.opacity(0.3))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.horizontal)
                
                HStack {
                    NavigationLink ("Forgot password?") {
                        ResetPasswordView()
                    }
                    
                    Spacer()
                    
                    NavigationLink("Join us!") {
                        SignInView()
                            .navigationBarBackButtonHidden()
                    }
                }
                .bold()
                .padding()

                Button {
                    vm.loginUser(loginStateService)
                } label: {
                    Text("Log in")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 55)
                        .background(Color.accentColor)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.horizontal)
                        .padding(.bottom)
                }
                
                Button {
                    print("BUTTON PRESSED")
                    vm.signInAnonymously()
                    self.loginStateService.state = .ANONYMOUSLY_LOGGED
                } label: {
                    Text("Log in anonymously")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 55)
                        .background(Color.secondary)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.horizontal)
                        .padding(.bottom)
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
    LoginView()
}
