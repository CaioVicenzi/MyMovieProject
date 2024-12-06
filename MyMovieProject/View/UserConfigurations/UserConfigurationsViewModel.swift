import Foundation
import FirebaseAuth
import FirebaseFirestore

class UserConfigurationsViewModel : ObservableObject {
    @Published var goOnboarding : Bool = false
    @Published var showAlertLogOut : Bool = false
    @Published var showAlertDeleteAccount : Bool = false
    @Published var showChangeNameView : Bool = false
    
    let db = Firestore.firestore()
    
    func logOut() {
        do {
            try Auth.auth().signOut()
            goOnboarding = true
        } catch {
            print("[ERROR] Couldn't log out")
        }
    }
    
    func deleteAccount() {
        Auth.auth().currentUser?.delete()
        goOnboarding = true
    }
    
    func getCurrentUserID() -> String {
        return Auth.auth().currentUser?.uid ?? ""
    }
    
    func changeUsername(name : String) async {
        if name.count >= 4 {
            guard let currentUser = Auth.auth().currentUser else {
                print("[ERROR] Could not get the currentUser")
                return
            }
            do {
                try await db.collection("user_data")
                    .whereField("id", isEqualTo: getCurrentUserID())
                    .getDocuments()
                    .documents
                    .first?
                    .reference.updateData([
                        "name" : name
                    ])
            } catch {
                print("[ERROR] Error updating username \(error.localizedDescription)")
            }
            
        } else {
            print("[DEBUG] couldn't change displayName")
        }
    }
}
