import Foundation
import FirebaseAuth

class ResetPasswordViewModel : ObservableObject {
    @Published var email : String = ""
    @Published var goSuccessfullyResetView = false

    func resetPassword () {
        Auth.auth().sendPasswordReset(withEmail: email)
        goSuccessfullyResetView = true
    }
}
