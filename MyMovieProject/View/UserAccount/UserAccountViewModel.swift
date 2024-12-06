import Foundation
import FirebaseAuth
import FirebaseFirestore
import SwiftData

class UserAccountViewModel : ObservableObject {
    let db = Firestore.firestore()
    @Published var favoriteMovies : [FavoriteMovieModelAccountView] = []
    @Published var waiting : Bool = false
    @Published var currentUserName : String = ""
    
    var modelContext : ModelContext? = nil
    
    func config(modelContext : ModelContext) {
        self.modelContext = modelContext
    }
    
    func getUserDisplayName () {
        let uid = getUserID()
        
        Task {
            do {
                let documents = try await db.collection("user_data")
                    .whereField("id", isEqualTo: uid)
                    .getDocuments()
                    .documents
                
                DispatchQueue.main.sync {
                    self.currentUserName = documents.first?.data()["name"] as? String ?? ""
                }
            } catch {
                print("[ERROR] Error fetching user name... \(error.localizedDescription)")
            }
        }
    }
    
    func getUserID () -> String {
        if let displayName = Auth.auth().currentUser?.uid {
            return displayName
        } else {
            return ""
        }
    }
    
    func fetchAllFavoritedMoviesFromCurrentUser () async {
        guard let modelContext else {
            print("[ERROR] There is no model context in UserAccountViewModel.")
            return
        }
        
        DispatchQueue.main.sync {
            self.favoriteMovies = []
        }
        
        let userID = getUserID()
        
        do {
            let favorited = try modelContext.fetch(FetchDescriptor<Favorite>(predicate: #Predicate{ element in
                element.uid == userID
            }))
            
            for favorite in favorited {
                await favoriteMovies.append(FavoriteMovieModelAccountView(movieID: favorite.movieID, movieName: getMovieNameByID(favorite.movieID.description)))
            }
        } catch {
            print("[ERROR] Could not fetch favorited movies...")
        }
    }
    
    func onAppearView () {
        Task {
            getUserDisplayName()
            await fetchAllFavoritedMoviesFromCurrentUser()
        }
    }
    
    func getMovieNameByID (_ movieID : String) async -> String {
        var title : String = ""
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieID.description)")!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "language", value: "en-US"),
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJkYWRkMTc3ZWFlZWJjM2M1M2ZjZmM2OGNmY2ZiMmJkMyIsIm5iZiI6MTcxMDc4NDA4Ni43MDg5OTk5LCJzdWIiOiI2NWY4N2U1NmUxOTRiMDAxNjNiZjQxODYiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.yMEfLcsm8uM6QgNiVq-TiNEvcDUWl3sqfxq2Vpe9V3E"
        ]
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let decodedData = try JSONDecoder().decode(MovieDetail.self, from: data)
            title = decodedData.title
        } catch {
            print("[ERROR] pobrema")
        }
        
        return title
    }
    
    func unfavoriteMovie(_ id : Int) {
        do {
            let userID = getUserID()
            let favorite = try modelContext?.fetch(FetchDescriptor<Favorite>(predicate: #Predicate{ favorite in
                favorite.movieID == id && favorite.uid == userID
            }))
            
            if let favoriteToDelete = favorite?.first {
                modelContext?.delete(favoriteToDelete)
            }

        } catch {
            print("[ERROR] error unfavoriting movie: \(error.localizedDescription)")
        }
        
        Task {
            await self.fetchAllFavoritedMoviesFromCurrentUser()
        }
    }
}
