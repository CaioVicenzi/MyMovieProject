import Foundation
import FirebaseAuth

struct AuthDataResultModel {
    let uid : String
    let email : String
    let displayName : String?
    
    init(_ user : User) {
        self.uid = user.uid
        self.email = user.email ?? ""
        self.displayName = user.displayName
    }
}
