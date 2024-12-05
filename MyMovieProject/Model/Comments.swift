import Foundation

class Comment {
    let title : String
    let movieID : Int
    let username : String
    let userID : String
    let id : String
    let movieTitle : String
    
    init(title: String, moovieID: Int, username : String, userID : String, id : String, movieTitle : String = "") {
        self.title = title
        self.movieID = moovieID
        self.username = username
        self.userID = userID
        self.id = id
        self.movieTitle = movieTitle
    }
}
