import Combine

class NewsTableViewModel: ObservableObject {
    @Published var news: ResultModel
    
    private var isFetch: Bool = true
    private let service = NewsService()
    
    init(news: ResultModel) {
        self.news = news
    }
    
    func getNews(page: Int) {
        if isFetch {
            Task {
                let result = await service.getNews(page: page)
                
                Task { @MainActor in
                    switch result {
                    case .success(let t):
                        isFetch = !t.articles.isEmpty
                        news.status = t.status
                        news.totalResults = t.totalResults
                        news.articles.append(contentsOf: t.articles)
                    default:
                        break
                    }
                }
            }
        }
    }
}
