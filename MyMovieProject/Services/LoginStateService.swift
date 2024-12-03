import Foundation

class LoginStateService : ObservableObject {
    @Published var state : LoginState
    
    init() {
        self.state = .NONE
    }
    
    enum LoginState {
        case LOGGED_IN
        case NONE
        case ANONYMOUSLY_LOGGED
    }
}
