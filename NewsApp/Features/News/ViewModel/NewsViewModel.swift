import Combine

class NewsViewModel: ObservableObject {
    @Published var status: APIResult<ResultModel> = .loading
    
    private let service = NewsService()
    
    init() {
        loadFirstNews()
    }
    
    func loadFirstNews() {
        Task {
            let result = await service.getNews(page: 1)
            Task { @MainActor in
                status = result
            }
        }
    }
}
