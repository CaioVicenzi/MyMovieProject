import SwiftUI

struct HomeView: View {
    @StateObject var vm = HomeViewModel()
    @EnvironmentObject var loginStateService : LoginStateService
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        VStack {
            VStack {
                if vm.isLoading && vm.movies.isEmpty {
                    ProgressView("Carregando filmes...")
                } else if let errorMessage = vm.errorMessage, vm.movies.isEmpty {
                    Text("Erro: \(errorMessage)")
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                } else {
                    HStack {
                        Button {
                            withAnimation(.smooth) {
                                vm.favoriteMoviesFiltered.toggle()
                            }
                        } label: {
                            RoundedRectangle(cornerRadius: 10)
                                .frame(height: 30)
                                .frame(width: 140)
                                .padding(.horizontal)
                                .foregroundStyle(vm.favoriteMoviesFiltered ? Color.green : .gray)
                                .overlay {
                                    HStack {
                                        Text("Favoritados")
                                            .font(.callout)
                                        Image(systemName: "star.fill")
                                    }
                                    .tint(.primary)
                                }
                        }
                        Spacer()
                    }
                    
                        
                    List {
                        ForEach(vm.movies, id: \.id) { movie in
                            if  vm.showMovie(movie: movie) {
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
                                                .progressViewStyle(CircularProgressViewStyle())
                                                .frame(width: 50, height: 75)
                                        }
                                        
                                        VStack(alignment: .leading) {
                                            Text(movie.title)
                                                .font(.headline)
                                            Text(movie.releaseDate)
                                                .font(.subheadline)
                                                .foregroundColor(.secondary)
                                        }
                                        
                                        Spacer()
                                        
                                        VStack {
                                            Spacer()
                                            if vm.movieIsFavorited(movie.id){
                                                Image(systemName: "star.fill")
                                                    .foregroundStyle(.purple)
                                            }
                                            Spacer()
                                            Spacer()
                                        }
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
                    .searchable(text: $vm.search)
                }
            }
            .navigationTitle("My Movie Project")
            .onAppear {
                vm.onLoadView(modelContext)
            }
            .toolbar {
                ToolbarItem(placement: self.loginStateService.state == .ANONYMOUSLY_LOGGED ? .topBarLeading : .topBarTrailing) {
                    NavigationLink {
                        UserAccountView()
                    }label: {
                        Image(systemName: "person.circle.fill")
                    }
                }
                  
                if self.loginStateService.state == .ANONYMOUSLY_LOGGED {
                    ToolbarItem(placement: .topBarTrailing) {
                        NavigationLink ("Login") {
                            LoginView()
                        }
                        .bold()
                    }
                }
            }
        }
    }
}
