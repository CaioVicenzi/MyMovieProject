import SwiftUI

struct MovieDetailView: View {
    @StateObject var vm = MovieDetailViewModel()
    let movie : MovieDetailResponse
    
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 30)
                .foregroundStyle(Color.darkPurple)
                .frame(height: 260)
                .offset(y: -10)
                .overlay (alignment: .leading){
                    VStack (alignment: .leading){
                        
                        Spacer()
                        Spacer()
                        Text(movie.title)
                            .font(.title)
                            .bold()
                        Spacer()
                        Text("Popularity: \(String(format: "%.2f", movie.popularity))")
                        Spacer()
                    }
                    .padding()

                    
                }
            
            ScrollView {
                
                VStack (alignment: .leading) {
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
                            Text(gender.name)
                        }
                        
                    }
                    .padding(.horizontal)
                    Spacer()
                }
                
                Divider()
                
                AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w1280/\(self.movie.posterPath)"), content: { returnedImage in
                    returnedImage
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.main.bounds.size.width - 40)
                        .padding()
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        
                }) {
                    ProgressView("Loading image")
                        .frame(height: 200)
                }
                
#warning("Fazer comentários")
                Text("Comentários")
                
                Spacer()
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    MovieDetailView(movie: MovieDetailResponse(adult: false, backdropPath: "/3V4kLQg0kSqPLctI5ziYWabAZYF.jpg", genres: [Genre(name: "Comédia"), Genre(name: "Ação")], id: 912649, imdbID: "", originalLanguage: "en", originalTitle: "Venom: The Last Dance", overview: "Eddie and Venom are on the run. Hunted by both of their worlds and with the net closing in, the duo are forced into a devastating decision that will bring the curtains down on Venom and Eddie's last dance.", popularity: 2767.29, posterPath: "/aosm8NMQ3UyoBVpSxyimorCQykC.jpg", releaseDate: "2024-10-22", runtime: 0, status: "", tagline: "", title: "Venom: The Last Dance"))
    
    /*
     "adult": false,
     "backdrop_path": "/3V4kLQg0kSqPLctI5ziYWabAZYF.jpg",
     "genre_ids": [
       878,
       28,
       12
     ],
     "id": 912649,
     "original_language": "en",
     "original_title": "Venom: The Last Dance",
     "overview": "Eddie and Venom are on the run. Hunted by both of their worlds and with the net closing in, the duo are forced into a devastating decision that will bring the curtains down on Venom and Eddie's last dance.",
     "popularity": 2767.29,
     "poster_path": "/aosm8NMQ3UyoBVpSxyimorCQykC.jpg",
     "release_date": "2024-10-22",
     "title": "Venom: The Last Dance",
     "video": false,
     "vote_average": 6.399,
     "vote_count": 915
   },
     */
}
