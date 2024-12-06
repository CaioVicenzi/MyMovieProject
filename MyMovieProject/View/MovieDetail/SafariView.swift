import SwiftUI
import SafariServices

// Wrapper para usar o SafariViewController em SwiftUI
struct SafariViewControllerWrapper: View {
    let url: URL
    
    // A apresentação do Safari é realizada com o UIKit via UIViewControllerRepresentable
    var body: some View {
        SafariViewController(url: url)
            .edgesIgnoringSafeArea(.all)
    }
}

// Implementando o UIViewControllerRepresentable para integrar o SafariViewController com SwiftUI
struct SafariViewController: UIViewControllerRepresentable {
    let url: URL
    
    // Método para criar o UIViewController (SafariViewController)
    func makeUIViewController(context: Context) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }
    
    // Método para atualizar o UIViewController, mas não precisamos atualizar aqui
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
}
