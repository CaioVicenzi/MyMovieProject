import SwiftUI

struct OnboardingView: View {
    @StateObject var vm = OnboardingViewModel()
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    OnboardingView()
}
