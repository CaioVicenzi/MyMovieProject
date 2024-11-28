import Foundation
import FirebaseFirestore

class MovieDetailViewModel : ObservableObject {
    let movieID : Int
    let db = Firestore.firestore()
    @Published var comments : [Comment] = []
    @Published var comment : String = ""
    
    init(movieID: Int) {
        self.movieID = movieID
    }
    
    func fetchComments () async  {
        var comments : [Comment] = []
        
        do {
            let argument = try await db.collection("comment").getDocuments()
            for document in argument.documents {
                let data = document.data()
                let content = data["content"] as! String
                let movieID = data["movieID"] as! Int
                
                if movieID == self.movieID {
                    comments.append(Comment(title: content, moovieID: movieID))
                }
                
            }
        } catch {
            print("Error on fetching data \(error)")
        }
        self.comments = comments
    }
    
    func saveComment () async {
        do {
            try await db.collection("comment").addDocument(data: [
                "content": self.comment,
                "id" : UUID().uuidString,
                "movieID": movieID
            ])
            
            await fetchComments()
        } catch {
            print("Erro ao adicionar o documento...")
        }
        
    }
}
