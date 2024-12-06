import Foundation
import FirebaseAuth
import SwiftData

@MainActor
class HomeViewModel: ObservableObject {
    @Published var movies: [ApiResult] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var goLoginView : Bool = false
    
    @Published var idFavoriteMovies : [Int] = []
    
    private var currentPage: Int = 1
    private var hasMorePages: Bool = true
    
    private let api = MovieApi()
    
    var modelContext : ModelContext? = nil
    
    func configure(_ modelContext : ModelContext) {
        self.modelContext = modelContext
    }
    
    func fetchPopularMovies() {
        guard !isLoading && hasMorePages else { return }
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let action = MovieApiAction<ListMovieResponse>.list(page: currentPage)
                let response = try await api.makeRequest(action: action)
                
                movies.append(contentsOf: response.results)
                
                hasMorePages = !response.results.isEmpty
                currentPage += 1
            } catch {
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }
    
    func onLoadView(_ modelContext : ModelContext) {
        self.configure(modelContext)
        if movies.isEmpty {
            fetchPopularMovies()
        }
        self.fetchFavoriteMovies()
    }
    
    func fetchFavoriteMovies() {
        guard let modelContext else {
            print("[ERROR] No model context found")
            return
        }
        
        self.idFavoriteMovies = []
        
        do {
            let currentUserID = Auth.auth().currentUser?.uid ?? ""
            
            let favorites = try modelContext.fetch(FetchDescriptor<Favorite>(predicate: #Predicate { favorite in
                favorite.uid == currentUserID
            }))
            
            for favorite in favorites {
                self.idFavoriteMovies.append(favorite.movieID)
            }
        } catch {
            print("[ERROR] Error fetching the favorite movies: \(error.localizedDescription)")
        }
    }
    
    func movieIsFavorited (_ idMovie : Int) -> Bool {
        self.idFavoriteMovies.contains(idMovie)
    }
}
