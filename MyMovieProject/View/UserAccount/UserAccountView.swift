import SwiftUI

struct UserAccountView: View {
    @StateObject var vm = UserAccountViewModel()

    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    UserAccountView()
}
