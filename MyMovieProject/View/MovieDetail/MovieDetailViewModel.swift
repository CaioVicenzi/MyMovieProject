import Foundation
import FirebaseFirestore
import FirebaseAuth

@MainActor
class MovieDetailViewModel : ObservableObject {
    let movieID : Int
    
    let db = Firestore.firestore()
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var comments : [Comment] = []
    @Published var comment : String = ""
    @Published var likes : Int = 0
    @Published var didUserLiked : Bool = false
    @Published var waiting : Bool = false
    @Published var movieDetail: MovieDetail?
    @Published var showAlertLogin : Bool = false
    @Published var goLoginView : Bool = false
    @Published var loginAlertTitle : String = ""
    
    private let api = MovieApi()
    
    init(movieID: Int) {
        self.movieID = movieID
    }
    
    func fetchComments () async  {
        var comments: [Comment] = []
        
        do {
            let argument = try await db.collection("comment").getDocuments()
            for document in argument.documents {
                let data = document.data()
                let content = data["content"] as! String
                let movieID = data["movieID"] as! Int
                let username = data["username"] as! String
                
                if movieID == self.movieID {
                    comments.append(Comment(title: content, moovieID: movieID, username: username))
                }
            }
        } catch {
            print("[ERROR] Couldn't fetch comment data: \(error)")
        }
        self.comments = comments
    }
    
    func saveComment (_ loginState : LoginStateService.LoginState) async {
        guard loginState == .LOGGED_IN else {
            self.loginAlertTitle = "You need to log in to comment this movie..."
            self.showAlertLogin = true
            return
        }
        
        self.waiting = true
        
        do {
            let userInfo = getCurrentUser()
            
            try await db.collection("comment").addDocument(data: [
                "content": self.comment,
                "id" : UUID().uuidString,
                "movieID": movieID,
                "userID": userInfo.1,
                "username": userInfo.0
            ])
            
            await fetchComments()
        } catch {
            print("[ERROR] Couldn't add document in database...")
        }
        self.waiting = false
    }
    
    func getCurrentUser () -> (String, String) {
        let currentUser = Auth.auth().currentUser
        
        if let currentUser, let displayName = currentUser.displayName {
            return (displayName, currentUser.uid)
        }
        
        return ("", "")
    }
    
    func fetchLikes () async {
        do {
            var likes = 0
            let argument = try await db.collection("like").getDocuments()
            for document in argument.documents {
                let data = document.data()
                
                if data["movieID"] as? Int == self.movieID {
                    likes += 1
                    
                    if data["userID"] as? String == getCurrentUser().1 {
                        self.didUserLiked = true
                    }
                }
            }
            self.likes = likes

        } catch {
            print("[ERROR] Couldn't fetch comment data: \(error)")
        }
    }
    
    func verifyIfUserLiked (completion : (Bool) -> Void) async {
        let currentUserID = getCurrentUser().1
        do {
            let argument = try await db.collection("like").getDocuments()
            for document in argument.documents {
                let data = document.data()
                
                if data["userID"] as? String == currentUserID {
                    completion(true)
                    return
                }
            }
            
        } catch {
            print("AAA AAA AAAA")
        }
        completion(false)

    }
    
    func likeButtonPressed (_ loginState : LoginStateService.LoginState) {
        guard loginState == .LOGGED_IN else {
            self.loginAlertTitle = "You need to login to give this movie a like..."
            self.showAlertLogin = true
            return
        }
        
        Task {
            if self.waiting == true {
                return
            }
            
            await verifyIfUserLiked { liked in
                Task {
                    if liked {
                        await unlike()
                    } else {
                        await like()
                    }
                }
            }
            
            self.didUserLiked.toggle()
        }
    }
    
    func loginAlertButtonPressed () {
        self.goLoginView = true
    }
    
    func like () async {
        self.waiting = true
        let userInfo = getCurrentUser()
           
        do {
            try await db.collection("like").addDocument(data: [
                "id" : UUID().uuidString,
                "movieID": movieID,
                "userID": userInfo.1,
            ])
        } catch {
            print("[ERROR] Couldn't like correctly")
        }
        
        await fetchLikes()
        self.waiting = false
    }
    
    func unlike () async {
        self.waiting = true
        let currentUserID = getCurrentUser().1

        do {
            let documents = try await db.collection("like").getDocuments().documents
            for document in documents {
                let data = document.data()
                if data["userID"] as? String == currentUserID {
                    try await document.reference.delete()
                }
            }
            
        } catch {
            print("Caio")
        }
        
        await fetchLikes()
        self.waiting = false
        
    }
    
    func fetchDetailMovie() async {
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieID)")!
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
            self.movieDetail = decodedData
        } catch {
            print("[ERROR] Failed to fetch movie details: \(error)")
            self.errorMessage = "Failed to load movie details. Please try again."
        }
    }
}
