import Foundation

struct EndPoint {
    let path:    String
    var method:  HTTPMethod = .GET
    var query:   [String: String] = [:]
    var headers: [String: String] = [:]
    var body:    Data? = nil
}
