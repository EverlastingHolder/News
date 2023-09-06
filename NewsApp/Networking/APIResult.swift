import Foundation

enum APIResult<T: Hashable>: Equatable {
    case success(T)
    case loading
    case error
    case empty
}
