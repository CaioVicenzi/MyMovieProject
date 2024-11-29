import Foundation
import FirebaseAuth

final class LoginViewModel : ObservableObject {
    @Published var email : String = ""
    @Published var password : String = ""
    @Published var username : String = ""
    @Published var showAlertLoginFailed : Bool = false
    @Published var goHome : Bool = false
    
    @Published var waitingProcess : Bool = false
    
    
    func loginUser () {
        waitingProcess = true
        guard !email.isEmpty, !password.isEmpty else {
            waitingProcess = false
            return
        }
        
        Task {
            Auth.auth().signIn(withEmail: email, password: password) {[weak self] result, error in
                guard error == nil else {
                    self?.showAlertLoginFailed = true
                    self?.waitingProcess = false
                    return
                }
                
                self?.goHome = true
                self?.waitingProcess = false
            }
        }
    }
}
