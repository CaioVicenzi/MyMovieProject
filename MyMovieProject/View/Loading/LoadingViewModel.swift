import Foundation
import FirebaseAuth

class LoadingViewModel : ObservableObject {
    @Published var goHomeView : Bool = false
    @Published var goSignInView : Bool = false
    
    func verifyUserAuthenticated () -> AuthDataResultModel? {
        guard let user = Auth.auth().currentUser else {
            print("[DEBUG] Usuário não autenticado")
            return nil
        }
        
        return AuthDataResultModel(user)
    }
}
