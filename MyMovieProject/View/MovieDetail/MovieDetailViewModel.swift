import Foundation
import FirebaseFirestore
import FirebaseAuth

@MainActor
class MovieDetailViewModel : ObservableObject {
    let movieID : Int
    let db = Firestore.firestore()
    @Published var comments : [Comment] = []
    @Published var comment : String = ""
    @Published var likes : Int = 0
    @Published var didUserLiked : Bool = false
    @Published var waiting : Bool = false
    
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
    
    func saveComment () async {
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
    
    func likeButtonPressed () {
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
}
