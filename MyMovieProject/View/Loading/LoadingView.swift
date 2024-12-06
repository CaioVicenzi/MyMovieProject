import SwiftUI

struct LoadingView: View {
    @StateObject var vm = LoadingViewModel()
    @EnvironmentObject var loginStateService : LoginStateService
    
    var body: some View {
        VStack {
            ProgressView("Carregando informações")
                .onAppear(perform: {
                    let authUser = vm.verifyUserAuthenticated()
                    vm.goSignInView = authUser == nil ? true : false
                    
                    if vm.goSignInView {
                        loginStateService.state = .NONE
                    } else {
                        loginStateService.state = .LOGGED_IN
                    }
                    
                    vm.goHomeView = !vm.goSignInView
                })
                .fullScreenCover(isPresented: $vm.goHomeView) {
                    NavigationStack {
                        HomeView()
                            .navigationBarBackButtonHidden()
                    }
                }
                .fullScreenCover(isPresented: $vm.goSignInView, content: {
                    NavigationStack {
                        OnboardingView()
                    }
                })
        }
        
    }
}

#Preview {
    LoadingView()
}
