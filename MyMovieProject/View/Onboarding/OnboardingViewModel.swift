import Foundation
import SwiftUI

class OnboardingViewModel : ObservableObject {
    @AppStorage("username") var usernameStorage : String = ""
    @AppStorage("alreadyLog") var alreadyLog : Bool = false
    
    func finishInput (_ username : String) {
        usernameStorage = username
        self.alreadyLog = true
    }
}
