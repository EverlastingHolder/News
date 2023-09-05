import UIKit
import CoreData

class NewsTableViewCell: UITableViewCell {
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var creatorLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var newsImage: UIImageView!
    @IBOutlet private weak var favoriteButton: UIButton!
    @IBOutlet private weak var publishedDateLabel: UILabel!
    
    @IBOutlet weak var newsImageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var newsImageHeightLowConstraint: NSLayoutConstraint!
    
    var newsModel: NewsModel? = nil
    private var isFavorite: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpView()
    }
    
    @IBAction func addFavorite(_ sender: UIButton) {
        if !isFavorite {
            if let news = newsModel {
                addFavoriteNews(newsModel: news)
            }
        } else {
            removeNews()
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
                setImageButton(isFavorite: false)
            }
        }
    }
    
    private func addFavoriteNews(newsModel: NewsModel) {
        let managedContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
        let news = News(context: managedContext)
        news.setValue(Date(), forKey: #keyPath(News.addDate))
        news.setValue(newsModel.title, forKey: #keyPath(News.title))
        news.setValue(newsModel.content, forKey: #keyPath(News.content))
        news.setValue(newsImage.image?.pngData(), forKey: #keyPath(News.image))
        news.setValue(newsModel.publishedAt, forKey: #keyPath(News.publishedDate))
        AppDelegate.sharedAppDelegate.coreDataStack.saveContext()
        setImageButton(isFavorite: true)
    }
    
    private func setUpView() {
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 12
        
        newsImage.layer.cornerRadius = 12
    }
    
    private func setImageButton(isFavorite: Bool) {
        if isFavorite {
            favoriteButton.setImage(.init(systemName: "star.fill"), for: .normal)
        } else {
            favoriteButton.setImage(.init(systemName: "star"), for: .normal)
        }
    }
    
    func setData(cellType: NewsTableViewCellModel) {
        creatorLabel.text = cellType.creator
        titleLabel.text = cellType.title
        descriptionLabel.text = cellType.description
        publishedDateLabel.text = cellType.publishedDate
        isFavorite = cellType.isFavorite
        
        setImageButton(isFavorite: isFavorite)
        
        Task {
            await newsImage.loadImage(urlString: cellType.image, low: newsImageHeightLowConstraint, high: newsImageHeightConstraint)
        }
    }
}
