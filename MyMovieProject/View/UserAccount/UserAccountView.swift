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
            Group {
                Text("Movies that you favorited: ")
                    .font(.headline)
                
                if vm.favoriteMovies.isEmpty {
                    Text("No movie favorited yet...")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
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
            if loginState.state != .ANONYMOUSLY_LOGGED {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        UserConfigurationsView()
                    } label: {
                        Image(systemName: "gear")
                    }
                }
            }
        }
        .navigationTitle("Dashboard")
    }
}

#Preview {
    UserAccountView()
}
