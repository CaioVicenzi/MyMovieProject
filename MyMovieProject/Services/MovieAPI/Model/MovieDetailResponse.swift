import Foundation

struct MovieDetail: Codable {
    let id: Int
    let title: String
    let overview: String
    let releaseDate: String
    let runtime: Int?
    let genres: [Genre]
    let voteAverage: Double
    let voteCount: Int
    let posterPath: String?
    let backdropPath: String?
    let homepage: String?
    let tagline: String?
    let videos: [MovieVideo]? // Adicionando a lista de vídeos
    
    enum CodingKeys: String, CodingKey {
        case id, title, overview, runtime, genres, homepage, tagline, videos
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
    }
}

struct Genre: Codable {
    let id: Int
    let name: String
}
