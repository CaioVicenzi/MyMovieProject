import SwiftUI

struct SignInView: View {
    @ObservedObject private var vm = SignInViewModel()
    
    var body: some View {
        VStack (alignment: .leading, spacing: 0) {
            inputLabel("Username")
            TextField("Username...", text: $vm.username)
                .padding()
                .background(Color.gray.opacity(0.3))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.horizontal)
            
            inputLabel("Email")
            TextField("Email...", text: $vm.email)
                .padding()
                .background(Color.gray.opacity(0.3))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.horizontal)
            
            inputLabel("Password")
            SecureField("Password...", text: $vm.password)
                .padding()
                .background(Color.gray.opacity(0.3))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.horizontal)
            
            HStack {
                Spacer()
                NavigationLink("Already have an account? Log in") {
                    LoginView()
                        .navigationBarBackButtonHidden()
                }
                Spacer()
            }
            .bold()
            .padding(.horizontal)
            .padding(.top)
            
            Button {
                Task { vm.signIn() }
            } label: {
                Text("Sign in")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .background(Color.accentColor)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding()
            }
            
            Spacer()
        }
        .fullScreenCover(isPresented: $vm.presentLogIn, content: {
            LoginView()
        })
        .fullScreenCover(isPresented: $vm.goHome, content: {
            HomeView()
        })
        .overlay(content: {
            if vm.waitingProcess {
                ProgressView("authenticating...")
            }
        })
        .alert("It wasn't possible to register", isPresented: $vm.showFieldAlert, actions: {
            Button("OK") {
                vm.okButtonInvalidFieldAlertPressed()
            }
        }, message: {
            Text(vm.invalidFieldAlertMessage())
        })
        .navigationTitle("Sign In")
    }
    
    @ViewBuilder
    func inputLabel(_ text : String) -> some View {
        Text(text)
            .font(.callout)
            .fontWeight(.light)
            .padding(.horizontal)
            .padding(.top)
    }
}

#Preview {
    NavigationView {
        SignInView()
    }
}
