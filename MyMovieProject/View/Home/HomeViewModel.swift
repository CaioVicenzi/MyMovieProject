import Foundation
import FirebaseAuth

@MainActor
class HomeViewModel: ObservableObject {
    @Published var movies: [ApiResult] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var currentUserName : String = ""
    private var currentPage: Int = 1
    private var hasMorePages: Bool = true
    
    private let api = MovieApi()

    func signOut () {
        do {
            try Auth.auth().signOut()
        } catch {
            print("[ERROR] Couldn't sign out")
        }
    }

    func getUser () {
        let currentuser = Auth.auth().currentUser
        
        print("[DEBUG] the user is \(currentuser?.email ?? "[ERROR] no email")")
        
        if let username = currentuser?.displayName {
            currentUserName = username
        } else {
            print("[ERROR] Couldn't get the username")
            return
        }
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
}
