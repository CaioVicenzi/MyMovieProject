import Foundation
import SwiftData

class FavoriteManager : ObservableObject {
    var modelContext : ModelContext?
    var movieID : Int
    var userID : String
        
    init(movieID : Int, userID : String) {
        self.movieID = movieID
        self.userID = userID
    }
    
    func config (_ modelContext : ModelContext) {
        self.modelContext = modelContext
    }
    
    func verifyIfUserFavorited () throws -> Bool {
        guard let modelContext else {
            throw ModelContextNotFoundError(localizedDescription: "[ERROR] Model Context not found")
        }
        
        let favorites = try modelContext.fetch(FetchDescriptor<Favorite>(predicate: #Predicate { favorite in
            return favorite.movieID == movieID && favorite.uid == userID
        }))
        
        return favorites.count >= 1
    }
    
    func favorite () throws -> Bool {
        guard let modelContext else {
            throw ModelContextNotFoundError(localizedDescription: "[ERROR] Model Context not found")
        }
                
        let favorite = Favorite(uid: userID, movieID: self.movieID)
        modelContext.insert(favorite)
        
        try modelContext.save()
        return true
    }
    
    func unfavorite () throws -> Bool {
        guard let modelContext else {
            throw ModelContextNotFoundError(localizedDescription: "[ERROR] Model Context not found")
        }
        
        let favorites = try modelContext.fetch(FetchDescriptor<Favorite>(predicate: #Predicate{ favorite in
            return favorite.movieID == movieID && favorite.uid == userID
        }))
        
        if let firstFavorite = favorites.first {
            modelContext.delete(firstFavorite)
        }
        
        return false
    }
}


class ModelContextNotFoundError : Error, LocalizedError {
    var localizedDescription : String
    
    init(localizedDescription: String) {
        self.localizedDescription = localizedDescription
    }
}
