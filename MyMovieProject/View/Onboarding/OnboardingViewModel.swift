import Foundation
import SwiftUI

class OnboardingViewModel : ObservableObject {
    @AppStorage("username") var usernameStorage : String = ""
    @AppStorage("alreadyLog") var alreadyLog : Bool = false

    @Published var showInputUsername : Bool = false
    @Published var goHome : Bool = false
    
    func finishInput (_ username : String) {
        usernameStorage = username
        self.showInputUsername = false
        self.goHome = true
        self.alreadyLog = true
    }
}
