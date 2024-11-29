import Foundation

struct MovieDetailResponse: Codable {
    let adult: Bool
    let backdropPath: String
    let genres: [Genre]
    let id: Int
    let imdbID, originalLanguage, originalTitle, overview: String
    let popularity: Double
    let posterPath: String
    let releaseDate: String
    let runtime: Int
    let status, tagline, title: String
    
    var imageUrl: URL? {
        URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
    }
    
    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genres, id
        case imdbID = "imdb_id"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case runtime
        case status, tagline, title
    }
}

struct Genre: Codable {
    let name: String
}
