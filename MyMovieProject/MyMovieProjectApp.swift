import SwiftUI
import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct MyMovieProjectApp: App {
    @AppStorage("alreadyLog") var alreadyLog : Bool = false
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    let loginStateService = LoginStateService()
    
    var body: some Scene {
        WindowGroup {
            LoadingView()
                .environmentObject(loginStateService)
        }
    }
}
