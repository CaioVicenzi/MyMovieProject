import SwiftUI

struct ChangeUsernameView: View {
    @State var username : String = ""
    @Environment(\.dismiss) var dismiss
    
    var action : (String) -> Void
    
    var body: some View {
        NavigationView {
            VStack {
                Text("How do you want to be called?")
                TextField("Giovanni...", text: $username)
                    .padding()
                    .background(Color.gray.opacity(0.3))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding()
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        action(username)
                        dismiss()
                    }
                }
            }
        }
    }
}

