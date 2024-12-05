import Foundation
import FirebaseAuth

class UserConfigurationsViewModel : ObservableObject {
    @Published var goOnboarding : Bool = false
    @Published var showAlertLogOut : Bool = false
    @Published var showAlertDeleteAccount : Bool = false
    @Published var showChangeNameView : Bool = false
    
    func logOut () {
        do {
            try Auth.auth().signOut()
            goOnboarding = true
        } catch {
            print("[ERROR] Couldn't log out")
        }
    }
    
    func deleteAccount () {
        Auth.auth().currentUser?.delete()
        goOnboarding = true
    }
    
    func getUsername () -> String {
        if let username = Auth.auth().currentUser?.displayName {
            return username
        } else {
            print("[ERROR] Couldn't get the username")
            return ""
        }
    }
    
    func changeUsername (name : String) {
        if name.count >= 4 {
            guard let currentUser = Auth.auth().currentUser else {
                print("[ERROR] Could not get the currentUser")
                return
            }
            currentUser.displayName = name

            Auth.auth().updateCurrentUser(currentUser)
        } else {
            print("[DEBUG] couldn't change displayName")
        }
    }
    
}
