import Foundation

protocol NewsServiceType {
    func getNews(page: Int) async -> APIResult<ResultModel>
}

final class NewsService: NewsServiceType {
    private let baseNetwork = Networking()
    
    func getNews(page: Int) async -> APIResult<ResultModel> {
        await baseNetwork.request("top-headlines", query: ["page": page.description, "country": "kr"])
    }
}
