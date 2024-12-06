import Foundation

struct MovieVideo: Codable {
    let id: String
    let key: String
    let name: String
    let site: String
    
    var youtubeURL: URL? {
        guard site == "YouTube" else {
            return nil
        }
        return URL(string: "https://youtube.com/watch?v=\(key)")
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case key
        case name
        case site
    }
}

struct MovieVideosResponse: Decodable {
    let id: Int
    let results: [MovieVideo]
}
