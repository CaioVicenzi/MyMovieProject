import Foundation
import FirebaseAuth

class HomeViewModel : ObservableObject {
    @Published var goOnboarding : Bool = false
    @Published var currentUserName : String = ""
    
    func signOut () {
        do {
            try Auth.auth().signOut()
            goOnboarding = true
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
}
