import UIKit
import CoreData

class NewsDetailViewController: UIViewController {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var contentLabel: UILabel!
    @IBOutlet private weak var creatorLabel: UILabel!
    @IBOutlet private weak var newsImage: UIImageView!
    @IBOutlet private weak var publishedDateLabel: UILabel!
    @IBOutlet private weak var favoriteNavigationButton: UIBarButtonItem!
    
    @IBOutlet weak var low: NSLayoutConstraint!
    @IBOutlet weak var high: NSLayoutConstraint!
    
    var newsModel: NewsModel? = nil
    var isFavorite: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let news = newsModel {
            setUp(newsModel: news)
        }
    }
    
    @IBAction private func actionFavoriteButton(_ sender: UIBarButtonItem) {
        if !isFavorite {
            if let news = newsModel {
                addFavoriteNews(newsModel: news)
            }
        } else {
            removeNews()
        }
    }
    
    private func setImageButton(_ isFavorite: Bool) {
        if !isFavorite {
            favoriteNavigationButton.image = .init(systemName: "star")
            return
        }
        favoriteNavigationButton.image = .init(systemName: "star.fill")
    }
    
    private func setUp(newsModel: NewsModel) {
        titleLabel.text = newsModel.title
        contentLabel.text = newsModel.content
        creatorLabel.text = newsModel.author
        publishedDateLabel.text = newsModel.publishedAt
        
        setImageButton(isFavorite)
        
        Task {
            await newsImage.loadImage(urlString: newsModel.urlToImage, low: low, high: high)
        }
    }
    
    private func fetchNews(item: NewsModel) -> News? {
        let newsFetch: NSFetchRequest<News> = News.fetchRequest()
        let sortByDate = NSSortDescriptor(key: #keyPath(News.addDate), ascending: false)
        newsFetch.sortDescriptors = [sortByDate]
        do {
            let managedContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
            let results = try managedContext.fetch(newsFetch)
            return results.first(where: { item.content == $0.content && item.publishedAt == $0.publishedDate })
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
            return nil
        }
    }
    
    private func removeNews() {
        if let news = newsModel {
            if let fetch = fetchNews(item: news) {
                AppDelegate.sharedAppDelegate.coreDataStack.managedContext.delete(fetch)
                AppDelegate.sharedAppDelegate.coreDataStack.saveContext()
                setImageButton(false)
                isFavorite = false
            }
        }
    }
    
    private func addFavoriteNews(newsModel: NewsModel) {
        let managedContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
        let news = News(context: managedContext)
        news.setValue(Date(), forKey: #keyPath(News.addDate))
        news.setValue(newsModel.title, forKey: #keyPath(News.title))
        news.setValue(newsModel.author, forKey: #keyPath(News.author))
        news.setValue(newsModel.content, forKey: #keyPath(News.content))
        news.setValue(newsImage.image?.pngData(), forKey: #keyPath(News.image))
        news.setValue(newsModel.publishedAt, forKey: #keyPath(News.publishedDate))
        news.setValue(newsModel.description, forKey: #keyPath(News.newsDescription))
        AppDelegate.sharedAppDelegate.coreDataStack.saveContext()
        setImageButton(true)
        isFavorite = true
    }
}
