import Foundation

@MainActor
class HomeViewModel: ObservableObject {
    @Published var movies: [ApiResult] = [] // Armazena a lista de filmes populares
    @Published var isLoading: Bool = false  // Indica se a API está carregando
    @Published var errorMessage: String?    // Armazena mensagens de erro, se houver
    
    private let api = MovieApi() // Instância da classe API
    
    // Método para buscar filmes populares
    func fetchPopularMovies() {
        isLoading = true // Inicia o carregamento
        errorMessage = nil // Reseta a mensagem de erro
        
        Task {
            do {
                // Configura a ação para listar filmes populares (página 1)
                let action = MovieApiAction<ListMovieResponse>.list(page: 1)
                // Faz a requisição e decodifica os resultados
                let response = try await api.makeRequest(action: action)
                // Atualiza a lista de filmes
                movies = response.results
            } catch {
                // Captura erros e atualiza a mensagem de erro
                errorMessage = error.localizedDescription
            }
            isLoading = false // Finaliza o carregamento
        }
    }
}
