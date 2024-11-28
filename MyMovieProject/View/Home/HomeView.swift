import SwiftUI

struct HomeView: View {
    @StateObject var vm = HomeViewModel()
    @AppStorage("username") var usernameStorage : String = ""
    
    var body: some View {
        Text("Olá \(usernameStorage)")
    }
}

#Preview {
    HomeView()
}
