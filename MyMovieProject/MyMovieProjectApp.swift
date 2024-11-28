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
    
    var body: some Scene {
        WindowGroup {
            if alreadyLog {
                //HomeView()
                MovieDetailView(movie: MovieDetailResponse(adult: false, backdropPath: "/3V4kLQg0kSqPLctI5ziYWabAZYF.jpg", genres: [Genre(name: "Comédia"), Genre(name: "Ação")], id: 912649, imdbID: "", originalLanguage: "en", originalTitle: "Venom: The Last Dance", overview: "Eddie and Venom are on the run. Hunted by both of their worlds and with the net closing in, the duo are forced into a devastating decision that will bring the curtains down on Venom and Eddie's last dance.", popularity: 2767.29, posterPath: "/aosm8NMQ3UyoBVpSxyimorCQykC.jpg", releaseDate: "2024-10-22", runtime: 0, status: "", tagline: "", title: "Venom: The Last Dance"))
            } else {
                OnboardingView()
            }
        }
    }
}
