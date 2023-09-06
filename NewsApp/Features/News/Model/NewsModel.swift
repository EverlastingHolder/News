import Foundation

struct ResultModel: Codable, Hashable {
    var status: String
    var totalResults: Int
    var articles: [NewsModel]
}

struct NewsModel: Codable, Hashable {
    let source: SourceModel
    let author: String?
    let title: String
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String
    let content: String?
    
    var image: Data?
    
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
