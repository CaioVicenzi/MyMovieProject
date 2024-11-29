import SwiftUI

struct HomeView: View {
    @StateObject var vm = HomeViewModel()
    @AppStorage("username") var usernameStorage: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                Button ("Sign out") {
                    vm.signOut()
                }
                if vm.isLoading && vm.movies.isEmpty {
                    ProgressView("Carregando filmes...")
                } else if let errorMessage = vm.errorMessage, vm.movies.isEmpty {
                    Text("Erro: \(errorMessage)")
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                } else {
                    List {
                        ForEach(vm.movies, id: \.id) { movie in
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
            .navigationTitle("Bem-vindo, \(usernameStorage)!")
            .onAppear {
                if vm.movies.isEmpty {
                    vm.fetchPopularMovies()
                    vm.getUser()
                }
            }
        }
    }
}
