import UIKit

class NewsDetailViewController: UIViewController {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var contentLabel: UILabel!
    @IBOutlet private weak var creatorLabel: UILabel!
    @IBOutlet private weak var newsImage: UIImageView!
    @IBOutlet private weak var publishedDateLabel: UILabel!
    
    @IBOutlet weak var low: NSLayoutConstraint!
    @IBOutlet weak var high: NSLayoutConstraint!
    
    var news: NewsModel? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let news = news {
            setUp(newsModel: news)
        }
    }
    
    private func setUp(newsModel: NewsModel) {
        titleLabel.text = newsModel.title
        contentLabel.text = newsModel.content
        creatorLabel.text = newsModel.author
        publishedDateLabel.text = newsModel.publishedAt
        
        newsImage.layer.cornerRadius = 12
        
        Task {
            await newsImage.loadImage(urlString: newsModel.urlToImage, low: low, high: high)
        }
    }
}
