import Foundation

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case transport(Error)
    case noResponce
    case server(code: Int, data: Data?)
    case noData
    case decoding(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            "Invalid URL"
        case .transport(let error):
            "Transport error: \(error.localizedDescription)"
        case .noResponce:
            "No HTTP response"
        case .server(let code, _):
            "Server error: \(code)"
        case .noData:
            "No data"
        case .decoding(let error):
            "Decoding error: \(error.localizedDescription)"
        }
    }
}

extension NetworkError {
    var userMessage: String {
        switch self {
        case .invalidURL: return "Неверный адрес запроса."
        case .transport:  return "Проблема с подключением. Проверьте интернет."
        case .noResponce: return "Нет ответа от сервиса."
        case .server(let code, _): return "Ошибка сервера (\(code). Попробуйте позже."
        case .noData:     return "Пустой отет от сервера."
        case .decoding:   return "Не удалось обработать данные."
        }
    }
}
