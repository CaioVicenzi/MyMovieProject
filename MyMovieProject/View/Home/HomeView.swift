import SwiftUI

struct HomeView: View {
    @StateObject var vm = HomeViewModel()
    @EnvironmentObject var loginStateService : LoginStateService

    var body: some View {
        NavigationView {
            VStack {
                if vm.isLoading && vm.movies.isEmpty {
                    ProgressView("Carregando filmes...")
                } else if let errorMessage = vm.errorMessage, vm.movies.isEmpty {
                    Text("Erro: \(errorMessage)")
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                } else {
                    List {
                        ForEach(vm.movies, id: \.id) { movie in
                            NavigationLink {
                                MovieDetailView(movieID: movie.id)
                            } label: {
                                HStack {
                                    AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w200\(movie.posterPath)")) { image in
                                        image
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 50, height: 75)
                                            .cornerRadius(8)
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    
                                    VStack(alignment: .leading) {
                                        Text(movie.title)
                                            .font(.headline)
                                        Text(movie.releaseDate)
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                }

                            }
                        }
                        
                        if vm.isLoading {
                            ProgressView()
                                .frame(maxWidth: .infinity, alignment: .center)
                        } else if !vm.movies.isEmpty {
                            Color.clear
                                .onAppear {
                                    vm.fetchPopularMovies()
                                }
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                }
            }
            .navigationTitle(self.loginStateService.state == .ANONYMOUSLY_LOGGED || vm.currentUserName == "" ? "Welcome!" : "Welcome, \(vm.currentUserName)!")
            .onAppear {
                if vm.movies.isEmpty {
                    vm.fetchPopularMovies()
                    vm.getUser()
                }
            }
            .fullScreenCover(isPresented: $vm.goLoginView, content: {
                LoginView()
            })
            .toolbar {
                if self.loginStateService.state != .ANONYMOUSLY_LOGGED {
                    ToolbarItem(placement: .topBarLeading) {
                        NavigationLink {
                            UserAccountView()
                        }label: {
                            Image(systemName: "person.circle.fill")
                        }
                    }
                } else {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button ("Login") {
                            vm.goLoginView = true
                        }
                        .bold()
                    }
                }
            }
        }
    }
}
