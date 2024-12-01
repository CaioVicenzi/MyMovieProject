import Foundation
import FirebaseFirestore
import FirebaseAuth

class MovieDetailViewModel: ObservableObject {
    let movieID: Int
    let db = Firestore.firestore()
    @Published var comments: [Comment] = []
    @Published var comment: String = ""
    
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
    
    func saveComment() async {
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
    }
    
    func getCurrentUser () -> (String, String) {
        let currentUser = Auth.auth().currentUser
        
        if let currentUser, let displayName = currentUser.displayName {
            return (displayName, currentUser.uid)
        }
        
        return ("", "")
    }
}
