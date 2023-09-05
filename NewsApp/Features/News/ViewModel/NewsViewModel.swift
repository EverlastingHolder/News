import Combine

class NewsViewModel: ObservableObject {
    @Published var news: ResultModel = .init(status: "", totalResults: 1, articles: [])
    @Published var status: APIResult<ResultModel> = .loading
    
    private let service = NewsService()
    private var isFetch: Bool = true
    
    init() {
        loadFirstNews()
    }
    
    func loadFirstNews() {
        Task {
            let result = await service.getNews(page: 1)
            
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
                status = result
            }
        }
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
