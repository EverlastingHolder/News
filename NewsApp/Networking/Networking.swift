import Foundation

final class Networking {
    private let baseURL: String = "https://newsapi.org/v2/"
    private let session: URLSession = .shared
    private let decode: JSONDecoder = .init()
    
    func request<T: Codable>(
        _ path: String,
        method: HTTPMethod = .get,
        headers: [String: String] = [:],
        query: [String: String?] = [:],
        parameters: [String: Any] = [:]
    ) async -> APIResult<T> {
        var request = URLRequest(url: URL(string: baseURL + path)!)
        request.httpMethod = method.rawValue
        var query = query
        query.updateValue("3b7d00a9c1cf4402a2a20fae75d87aec", forKey: "apikey")
        request.url?.append(queryItems: query.map {
            URLQueryItem(name: $0, value: $1)
        })
        if method != .get {
            do {
                let data = try JSONSerialization.data(withJSONObject: parameters)
                request.httpBody = data
            } catch {
                print("Error JSONSerialization")
            }
            
        }
        print(request)
    
        return await response(request: request)
    }
    
    private func response<T: Codable>(request: URLRequest) async -> APIResult<T> {
        do {
            let (data, _) = try await session.data(for: request)
            return try .success(decode.decode(T.self, from: data))
        } catch(let error) {
            print(error)
            return .error
        }
    }
}
