import UIKit
import CoreData

class NewsDetailViewController: UIViewController {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var contentLabel: UILabel!
    @IBOutlet private weak var creatorLabel: UILabel!
    @IBOutlet private weak var newsImage: UIImageView!
    @IBOutlet private weak var publishedDateLabel: UILabel!
    @IBOutlet private weak var favoriteNavigationButton: UIBarButtonItem!
    @IBOutlet private weak var linkLabel: UILabel!
    
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
    
    private func setUpLink () {
        linkLabel.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(openLink))
        linkLabel.addGestureRecognizer(tap)
    }
    
    @objc private func openLink() {
        if let urlString = linkLabel.text, let url = URL(string: urlString) {
            UIApplication.shared.open(url)
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
        linkLabel.text = newsModel.url
        titleLabel.text = newsModel.title
        contentLabel.text = newsModel.content
        creatorLabel.text = newsModel.author
        publishedDateLabel.text = newsModel.publishedAt
        
        newsImage.layer.cornerRadius = 12
        
        setUpLink()
        
        setImageButton(isFavorite)
        
        if let data = newsModel.image, let image = UIImage(data: data) {
            low.priority = .defaultLow
            high.priority = .defaultHigh
            newsImage.image = image
        } else {
            Task {
                await newsImage.loadImage(urlString: newsModel.urlToImage, low: low, high: high)
            }
        }
    }
    
    private func removeNews() {
        if let news = newsModel {
            if let item = CoreDataService.shared.findNews(news) {
                CoreDataService.shared.removeNews(item)
                setImageButton(false)
                isFavorite = false
            }
        }
    }
    
    private func addFavoriteNews(newsModel: NewsModel) {
        CoreDataService.shared.addFavoriteNews(newsModel: newsModel, image: newsImage.image?.pngData())
        setImageButton(true)
        isFavorite = true
    }
}
