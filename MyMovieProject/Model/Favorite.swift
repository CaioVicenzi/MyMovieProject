import Foundation
import SwiftData

@Model
class Favorite {
    var uid : String
    var movieID : Int
    
    init(uid: String, movieID: Int) {
        self.uid = uid
        self.movieID = movieID
    }
}
