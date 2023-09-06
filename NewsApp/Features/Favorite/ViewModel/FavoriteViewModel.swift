import Combine
import CoreData

class FavoriteViewModel: ObservableObject {
    @Published var news: APIResult<[News]> = .loading
    
    func getNews() {
        news = fetchNews()
    }
    
    private func fetchNews() -> APIResult<[News]> {
        let result = CoreDataService.shared.fetchNews()
        if let news = result {
            if news.isEmpty {
                return .empty
            }
            return .success(news)
        }
        return .error
    }
}
