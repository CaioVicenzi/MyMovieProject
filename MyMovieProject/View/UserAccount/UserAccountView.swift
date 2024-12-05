import SwiftUI
import SwiftData

struct UserAccountView: View {
    @ObservedObject var vm: UserAccountViewModel
    @Environment(\.modelContext) var modelContext
    @EnvironmentObject var loginState : LoginStateService
    
    init() {
        self.vm = UserAccountViewModel()
    }
    
    var body: some View {
        VStack (alignment: .leading) {
            Text("Movies that you favorited: ")
                .font(.headline)
                .padding(.horizontal)
            List {
                ForEach(vm.favoriteMovies) { favoriteMovie in
                    NavigationLink {
                        MovieDetailView(movieID: favoriteMovie.movieID)
                    } label: {
                        Text(favoriteMovie.movieName)
                    }
                    .swipeActions {
                        Button("Unfavorite") {
                            vm.unfavoriteMovie(favoriteMovie.movieID)
                        }
                    }
                }
            }
        }
        .overlay(alignment: .center, content: {
            if vm.waiting {
                ProgressView("Loading")
            }
        })
        .onAppear(perform: {
            vm.config(modelContext: modelContext)
            vm.onAppearView()
        })
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    UserConfigurationsView()
                } label: {
                    Image(systemName: "gear")
                }
            }
        }
        .navigationTitle(loginState.state == .ANONYMOUSLY_LOGGED || vm.getUserDisplayName() == "" ? "Welcome!" : "Welcome, \(vm.getUserDisplayName())!")
    }
}

#Preview {
    UserAccountView()
}
