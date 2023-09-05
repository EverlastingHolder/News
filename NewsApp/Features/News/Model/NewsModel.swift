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
}

struct SourceModel: Codable, Hashable {
    let id: String?
    let name: String
}
