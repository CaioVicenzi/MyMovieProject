import Foundation

enum MovieApiAction<T: Codable> {
    case list(page: Int? = nil)
    case detail(movieId: Int)
    
    var baseURL: URL {
        return URL(string: "https://api.themoviedb.org/3")!
    }
    
    var path: String {
        switch self {
        case .list:
            return "/discover/movie"
        case let .detail(movieId):
            return "/movie/\(movieId)"
        }
    }
    
    var method: String {
        return "GET"
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case let .list(page):
            return [
                URLQueryItem(name: "include_adult", value: "false"),
                URLQueryItem(name: "include_video", value: "false"),
                URLQueryItem(name: "language", value: "en-US"),
                URLQueryItem(name: "page", value: "\(page ?? 1)"),
                URLQueryItem(name: "sort_by", value: "popularity.desc")
            ]
        case .detail:
            return [
                URLQueryItem(name: "language", value: "pt-BR")
            ]
        }
    }
    
    var url: URL {
        var components = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: true)!
        components.queryItems = queryItems
        return components.url!
    }
    
    var headers: [String: String] {
        return [
            "accept": "application/json",
            "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJkYWRkMTc3ZWFlZWJjM2M1M2ZjZmM2OGNmY2ZiMmJkMyIsIm5iZiI6MTczMjc0NjM2Mi40ODQzNDMzLCJzdWIiOiI2NWY4N2U1NmUxOTRiMDAxNjNiZjQxODYiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.vN-qCk3Pa4aYHt2KVSC_VaUXASvYBPhHtJTP7EG-zlo"
        ]
    }
}
