import Foundation

/// Essa classe é unicamente criada para trafegar dados dentro da UserAccountView e UserAccountViewModel.
final class FavoriteMovieModelAccountView : Identifiable {
    let movieID : Int
    let movieName : String
    
    init(movieID: Int, movieName: String) {
        self.movieID = movieID
        self.movieName = movieName
    }
}
