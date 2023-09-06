import Foundation

struct NewsTableViewCellModel {
    let title: String?
    let creator: String?
    let description: String?
    let imageUrl: String?
    let publishedDate: String?
    let image: Data?
    
    init(newsModel: NewsModel) {
        self.title = newsModel.title
        self.description = newsModel.description
        self.creator = newsModel.author
        self.imageUrl = newsModel.urlToImage
        self.publishedDate = newsModel.publishedAt
        self.image = nil
    }
    
    init(news: News) {
        self.title = news.title
        self.description = news.newsDescription
        self.publishedDate = news.publishedDate
        self.creator = news.author
        self.image = news.image
        self.imageUrl = nil
    }
}
