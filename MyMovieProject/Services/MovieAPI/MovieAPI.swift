import Foundation

class MovieApi {
    let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    private func makeURLRequest<T: Codable>(_ action: MovieApiAction<T>) throws -> URLRequest {
        var request = URLRequest(url: action.url)
        request.httpMethod = action.method
        action.headers.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        return request
    }
    
    public func makeRequest<T: Codable>(action: MovieApiAction<T>) async throws -> T {
        do {
            let request = try makeURLRequest(action)
            let (data, response) = try await session.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                throw MovieApiError.failedToMakeRequest
            }
            
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            throw MovieApiError.failedToDecodeApiResponse
        }
    }
}
