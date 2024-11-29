import Foundation

class Comment {
    let title : String
    let moovieID : Int
    let username : String
    
    init(title: String, moovieID: Int, username : String) {
        self.title = title
        self.moovieID = moovieID
        self.username = username
    }
}
