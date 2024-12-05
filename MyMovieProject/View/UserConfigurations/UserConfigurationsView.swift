import SwiftUI

struct UserConfigurationsView: View {
    @StateObject var vm = UserConfigurationsViewModel()

    var body: some View {
        VStack{
            HStack {
                Text("User settings")
                    .bold()
                    .font(.largeTitle)
                Spacer()
            }
            .padding(.horizontal)
            
            Spacer()
            
            List {
                Section {
                    Button ("Change username") {
                        vm.showChangeNameView = true
                    }
                }
                
                Section {
                    Button ("Log out") {
                        vm.showAlertLogOut = true
                    }
                    .tint(.red)
                    
                    Button("Delete account"){
                        vm.showAlertDeleteAccount = true
                    }
                    .tint(.red)
                }
            }
            
            Spacer()
        }
        .alert("Are you sure you want to log out?", isPresented: $vm.showAlertLogOut) {
            Button ("Yes", role: .destructive) {
                vm.logOut()
            }
            
            Button ("No", role: .cancel) {}
        }
        .alert("Are you sure you want to delete your account?", isPresented: $vm.showAlertDeleteAccount) {
            Button ("Yes", role: .destructive) {
                vm.deleteAccount()
            }
            
            Button ("No", role: .cancel) {}
        } message: {
            Text("This action can't be undone.")
        }
        .fullScreenCover(isPresented: $vm.goOnboarding) {
            OnboardingView()
        }
        .sheet(isPresented: $vm.showChangeNameView) {
            ChangeUsernameView {username in
                vm.changeUsername(name: username)
            }
            .presentationDetents([.fraction(0.3)])
        }

    }
}

#Preview {
    UserAccountView()
}
