import Foundation

struct NewsTableViewCellModel {
    let title: String
    let creator: String?
    let description: String?
    let image: String?
    
    init(newsModel: NewsModel) {
        self.title = newsModel.title
        self.description = newsModel.description
        self.creator = newsModel.author
        self.image = newsModel.urlToImage
    }
}
