import SwiftUI

struct InputUsernameView: View {
    @AppStorage("username") var usernameStorage : String = ""
    @AppStorage("alreadyLog") var alreadyLog : Bool = false
    
    @State var username : String = ""
    @Binding var goHome : Bool
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Como devemos te chamar?")
                TextField("Caio", text: $username)
                    .padding()
                    .background(Color.gray.opacity(0.3))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .padding(.horizontal)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button ("Pronto") {
                        usernameStorage = username
                        self.goHome = true
                        self.alreadyLog = true
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    InputUsernameView(goHome: .constant(false))
}
