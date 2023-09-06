import Foundation

struct ResultModel: Codable, Hashable {
    var status: String
    var totalResults: Int
    var articles: [NewsModel]
}

struct NewsModel: Codable, Hashable {
    let source: SourceModel
    let author: String?
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?
    
    var image: Data?
    
    init(news: News) {
        self.author = news.author
        self.publishedAt = news.publishedDate
        self.content = news.content
        self.description = news.newsDescription
        self.title = news.title
        self.image = news.image
        self.url = news.newsLink
        self.source = .init(id: nil, name: "")
        self.urlToImage = nil
    }
    
    private enum CodingKeys: CodingKey {
        case source
        case author
        case title
        case description
        case url
        case urlToImage
        case publishedAt
        case content
    }
}

struct SourceModel: Codable, Hashable {
    let id: String?
    let name: String
}
