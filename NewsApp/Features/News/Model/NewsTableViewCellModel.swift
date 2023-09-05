import Foundation

struct NewsTableViewCellModel {
    let title: String
    let creator: String?
    let description: String?
    let image: String?
    let isFavorite: Bool
    let publishedDate: String
    
    init(newsModel: NewsModel, isFavorite: Bool) {
        self.title = newsModel.title
        self.description = newsModel.description
        self.creator = newsModel.author
        self.image = newsModel.urlToImage
        self.publishedDate = newsModel.publishedAt
        self.isFavorite = isFavorite
    }
}
