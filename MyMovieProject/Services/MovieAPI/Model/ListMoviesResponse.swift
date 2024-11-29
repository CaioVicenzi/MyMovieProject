import Foundation

struct ListMovieResponse: Codable {
    let page: Int
    let results: [ApiResult]
}

struct ApiResult: Codable {
    let adult: Bool
    let id: Int
    let originalTitle, overview: String
    let posterPath, releaseDate, title: String
    
    enum CodingKeys: String, CodingKey {
        case adult
        case id
        case originalTitle = "original_title"
        case overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title
    }
}

