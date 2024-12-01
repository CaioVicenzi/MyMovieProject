import SwiftUI

struct MovieDetailView: View {
    @ObservedObject var vm: MovieDetailViewModel
    let movie: MovieDetailResponse
    
    init(movie: MovieDetailResponse) {
        self.vm = MovieDetailViewModel(movieID: movie.id)
        self.movie = movie
    }
    
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 30)
                .foregroundStyle(Color.darkPurple)
                .frame(height: 260)
                .offset(y: -10)
                .overlay(alignment: .leading) {
                    VStack(alignment: .leading) {
                        Spacer()
                        Spacer()
                        Text(movie.title)
                            .font(.title)
                            .bold()
                        Spacer()
                        HStack {
                            Text("Popularity: \(String(format: "%.2f", movie.popularity))")
                            Spacer()
                            Button {
                                vm.likeButtonPressed()
                            } label: {
                                VStack {
                                    Image(systemName: vm.didUserLiked ? "heart.fill" : "heart")
                                    Text(vm.likes.description)
                                }
                            }
                            .disabled(vm.waiting)
                        }
                        .padding(.trailing)
                        Spacer()
                    }
                    .padding()
                }
            
            ScrollView {
                VStack(alignment: .leading) {
                    Text("Description:")
                        .bold()
                        .padding(.vertical)
                    
                    Text(movie.overview)
                }
                .padding()
            
                HStack {
                    VStack (alignment: .leading) {
                        Text("Genders")
                            .bold()
                            .padding(.bottom)
                        
                        ForEach(movie.genres, id: \.name) {gender in
                            HStack {
                                Image(systemName: "chevron.right")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 10)
                                Text(gender.name)
                            }
                        }
                    }
                    .padding(.horizontal)
                    Spacer()
                }
                
                Divider()
                
                HStack {
                    Text("Comentários")
                        .font(.headline)
                        .bold()
                    Spacer()
                }
                .padding()
                
                VStack(alignment: .leading) {
                    HStack {
                        TextField("Eu gostei desse filme porque...", text: $vm.comment)
                        
                        if !vm.comment.isEmpty {
                            Button {
                                Task {
                                    await vm.saveComment()
                                }
                            } label: {
                                Image(systemName: "paperplane.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 30)
                            }
                        }
                    }
                }
                .padding(.horizontal)
                
                Divider()
                
                if vm.comments.isEmpty {
                    Text("Ainda não temos nenhum comentário associado a esse filme...")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .padding()
                } else {
                    ForEach(vm.comments, id: \.title) { comment in
                        RoundedRectangle(cornerRadius: 10)
                            .frame(height: 60)
                            .foregroundStyle(Color.gray.opacity(0.2))
                            .overlay(alignment: .leading) {
                                VStack (alignment: .leading) {
                                    Text(comment.username)
                                        .bold()
                                    Text(comment.title)
                                }
                                .padding(.leading)
                            }
                            .padding(.horizontal)
                    }
                }
                Spacer()
            }
        }
        .ignoresSafeArea()
        .onAppear {
            Task {
                self.vm.waiting = true
                await vm.fetchComments()
                await vm.fetchLikes()
                self.vm.waiting = false
            }
        }
        .overlay {
            if vm.waiting {
                ProgressView()
            }
        }
        .allowsHitTesting(!self.vm.waiting)
    }
}

#Preview {
    MovieDetailView(movie: MovieDetailResponse(adult: false, backdropPath: "/3V4kLQg0kSqPLctI5ziYWabAZYF.jpg", genres: [Genre(name: "Comédia"), Genre(name: "Ação")], id: 912649, imdbID: "", originalLanguage: "en", originalTitle: "Venom: The Last Dance", overview: "Eddie and Venom are on the run. Hunted by both of their worlds and with the net closing in, the duo are forced into a devastating decision that will bring the curtains down on Venom and Eddie's last dance.", popularity: 2767.29, posterPath: "/aosm8NMQ3UyoBVpSxyimorCQykC.jpg", releaseDate: "2024-10-22", runtime: 0, status: "", tagline: "", title: "Venom: The Last Dance"))
}
