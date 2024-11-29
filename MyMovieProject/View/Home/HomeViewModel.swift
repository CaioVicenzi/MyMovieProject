import Foundation

@MainActor
class HomeViewModel: ObservableObject {
    @Published var movies: [ApiResult] = [] // Armazena a lista de filmes populares
    @Published var isLoading: Bool = false  // Indica se a API está carregando
    @Published var errorMessage: String?    // Armazena mensagens de erro, se houver
    private var currentPage: Int = 1        // Página atual
    private var hasMorePages: Bool = true   // Indica se há mais páginas para carregar
    
    private let api = MovieApi() // Instância da classe API
    
    // Método para buscar filmes populares
    func fetchPopularMovies() {
        guard !isLoading && hasMorePages else { return } // Evita carregamentos simultâneos ou desnecessários
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                // Configura a ação para listar filmes populares na página atual
                let action = MovieApiAction<ListMovieResponse>.list(page: currentPage)
                let response = try await api.makeRequest(action: action)
                
                // Adiciona novos filmes à lista
                movies.append(contentsOf: response.results)
                
                // Atualiza o estado de carregamento
                hasMorePages = !response.results.isEmpty // Se a resposta estiver vazia, não há mais páginas
                currentPage += 1
            } catch {
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }
}
