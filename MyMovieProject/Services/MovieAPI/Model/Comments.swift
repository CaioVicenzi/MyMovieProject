import Foundation

class Comment {
    let title : String
    let movieID : Int
    let username : String
    
    init(title: String, moovieID: Int, username : String) {
        self.title = title
        self.movieID = moovieID
        self.username = username
    }
}
