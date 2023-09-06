import Combine
import UIKit
import Foundation

class NewsDetailViewModel: ObservableObject {
    @Published var isFavorite: Bool
    @Published var newsModel: NewsModel
    
    init(isFavorite: Bool, newsModel: NewsModel) {
        self.isFavorite = isFavorite
        self.newsModel = newsModel
    }
    
    func actionFavoriteButton(image: Data?) {
        if !isFavorite {
            addFavoriteNews(image: image)
        } else {
            removeNews()
        }
    }
    
    func openLink() {
        if let urlString = newsModel.url, let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
    
    private func removeNews() {
        if let item = CoreDataService.shared.findNews(newsModel) {
            CoreDataService.shared.removeNews(item)
            isFavorite = false
        }
    }
    
    private func addFavoriteNews(image: Data?) {
        CoreDataService.shared.addFavoriteNews(newsModel: newsModel, image: image)
        isFavorite = true
    }
}
