import Combine

class FavoriteTableViewModel: ObservableObject {
    @Published var news: [News]
    
    init(news: [News]) {
        self.news = news
    }
}
