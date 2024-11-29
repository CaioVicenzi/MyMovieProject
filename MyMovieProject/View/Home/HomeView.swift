import SwiftUI

struct HomeView: View {
    @StateObject var vm = HomeViewModel()
    //@AppStorage("username") var usernameStorage: String = ""
    
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
                        NavigationLink("Filme do Venom") {
                            MovieDetailView(movie: MovieDetailResponse(adult: false, backdropPath: "/3V4kLQg0kSqPLctI5ziYWabAZYF.jpg", genres: [Genre(name: "Comédia"), Genre(name: "Ação")], id: 912649, imdbID: "", originalLanguage: "en", originalTitle: "Venom: The Last Dance", overview: "Eddie and Venom are on the run. Hunted by both of their worlds and with the net closing in, the duo are forced into a devastating decision that will bring the curtains down on Venom and Eddie's last dance.", popularity: 2767.29, posterPath: "/aosm8NMQ3UyoBVpSxyimorCQykC.jpg", releaseDate: "2024-10-22", runtime: 0, status: "", tagline: "", title: "Venom: The Last Dance"))

                        }
                        
                        
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
            .navigationTitle("Bem-vindo, \(vm.currentUserName)!")
            .onAppear {
                if vm.movies.isEmpty {
                    vm.fetchPopularMovies()
                    vm.getUser()
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    NavigationLink {
                        UserAccountView()
                    }label: {
                        Image(systemName: "person.circle.fill")
                    }
                }
            }
        }
    }
}
