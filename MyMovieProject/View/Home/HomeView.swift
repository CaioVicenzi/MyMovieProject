import SwiftUI

struct HomeView: View {
    @StateObject var vm = HomeViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Olá \(vm.currentUserName)")
                Button ("Sign out") {
                    vm.signOut()
                    
                }
                
                NavigationLink("Filme do Venom") {
                    MovieDetailView(movie: MovieDetailResponse(adult: false, backdropPath: "/3V4kLQg0kSqPLctI5ziYWabAZYF.jpg", genres: [Genre(name: "Comédia"), Genre(name: "Ação")], id: 912649, imdbID: "", originalLanguage: "en", originalTitle: "Venom: The Last Dance", overview: "Eddie and Venom are on the run. Hunted by both of their worlds and with the net closing in, the duo are forced into a devastating decision that will bring the curtains down on Venom and Eddie's last dance.", popularity: 2767.29, posterPath: "/aosm8NMQ3UyoBVpSxyimorCQykC.jpg", releaseDate: "2024-10-22", runtime: 0, status: "", tagline: "", title: "Venom: The Last Dance"))
                    
                }
            }
            .onAppear {
                vm.getUser()
            }
            .fullScreenCover(isPresented: $vm.goOnboarding) {
                OnboardingView()
                    .navigationBarBackButtonHidden()
            }
        }
        
        
    }
}

#Preview {
    HomeView()
}
