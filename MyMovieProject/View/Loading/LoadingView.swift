import SwiftUI

struct LoadingView: View {
    @StateObject var vm = LoadingViewModel()
    
    var body: some View {
        NavigationStack {
            ProgressView("Carregando informações")
                .onAppear(perform: {
                    let authUser = vm.verifyUserAuthenticated()
                    vm.goSignInView = authUser == nil ? true : false
                    vm.goHomeView = !vm.goSignInView
                })
                .fullScreenCover(isPresented: $vm.goHomeView) {
                    HomeView()
                        .navigationBarBackButtonHidden()
                }
                .fullScreenCover(isPresented: $vm.goSignInView, content: {
                    OnboardingView()
                })
        }
        
    }
}

#Preview {
    LoadingView()
}
