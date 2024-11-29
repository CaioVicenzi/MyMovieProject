import Foundation

enum MovieApiError: Error {
    case failedToBuildRequest
    case failedToMakeRequest
    case failedToDecodeApiResponse
}

extension MovieApiError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .failedToBuildRequest:
            return "Não foi possível construir a requisição, verifique a chave de API."
        case .failedToMakeRequest:
            return "Houve um problema ao fazer a requisição."
        case .failedToDecodeApiResponse:
            return "Formato de resposta incorreto."
        }
    }
}
