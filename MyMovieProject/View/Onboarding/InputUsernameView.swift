import SwiftUI

struct InputUsernameView: View {
    
    
    @State var username : String = ""
    @Binding var goHome : Bool
    @Environment(\.dismiss) var dismiss
    
    let onFinish : (String) -> Void
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("How can we call you?")
                TextField("Caio", text: $username)
                    .padding()
                    .background(Color.gray.opacity(0.3))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .padding(.horizontal)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button ("Done") {
                        onFinish(username)
                    }
                }
            }
        }
    }
}

#Preview {
    InputUsernameView(goHome: .constant(false)) {username in
        print(username)
    }
}
