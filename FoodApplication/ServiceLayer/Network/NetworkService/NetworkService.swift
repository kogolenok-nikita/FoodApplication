import Foundation

protocol NetworkServiceProtocol {
    func request<T: Decodable>(_ endpoint: EndPoint, completion: @escaping (Result<T, NetworkError>) -> Void)
}

final class NetworkService: NetworkServiceProtocol {
    private let baseURL: URL
    private let session: URLSession
    private let decoder: JSONDecoder
    
    init(baseURL: URL, session: URLSession = .shared) {
        self.baseURL = baseURL
        self.session = session
        self.decoder = JSONDecoder()
        self.decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    private func makeRequest(from endPoint: EndPoint) -> URLRequest? {
        var components = URLComponents(url: baseURL.appendingPathComponent(endPoint.path), resolvingAgainstBaseURL: false)
        if !endPoint.query.isEmpty {
            components?.queryItems = endPoint.query.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        guard let url = components?.url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = endPoint.method.rawValue
        request.httpBody = endPoint.body
        endPoint.headers.forEach { request.addValue($0.value, forHTTPHeaderField: $0.key) }
        return request
    }
    
    func request<T: Decodable>(_ endPoint: EndPoint, completion: @escaping (Result<T, NetworkError>) -> Void) {
        guard let request = makeRequest(from: endPoint) else {
            completion(.failure(.invalidURL))
            return
        }
        session.dataTask(with: request) { data, response, error in
            let result: Result<T, NetworkError> = Self.parse(data: data, response: response, error: error, decoder: self.decoder)
            DispatchQueue.main.async {
                completion(result)
            }
        }.resume()
    }
    
    private static func parse<T: Decodable>(data: Data?, response: URLResponse?, error: Error?, decoder: JSONDecoder) -> Result<T, NetworkError> {
        if let error { return .failure(.transport(error)) }
        guard let http = response as? HTTPURLResponse else { return .failure(.noResponce) }
        guard (200...299).contains(http.statusCode) else { return .failure(.server(code: http.statusCode, data: data)) }
        guard let data else { return .failure(.noData) }
        do {
            return .success(try decoder.decode(T.self, from: data))
        }
        catch {
            return .failure(.decoding(error))
        }
    }
}
