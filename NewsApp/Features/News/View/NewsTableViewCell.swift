import UIKit
import CoreData

class NewsTableViewCell: UITableViewCell {
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var creatorLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var newsImage: UIImageView!
    @IBOutlet private weak var publishedDateLabel: UILabel!
    
    @IBOutlet weak var newsImageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var newsImageHeightLowConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpView()
    }
    
    private func setUpView() {
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 12
        
        newsImage.layer.cornerRadius = 12
    }
    
    func setData(cellType: NewsTableViewCellModel) {
        creatorLabel.text = cellType.creator
        titleLabel.text = cellType.title
        descriptionLabel.text = cellType.description
        publishedDateLabel.text = cellType.publishedDate
        
        Task {
            await newsImage.loadImage(urlString: cellType.image, low: newsImageHeightLowConstraint, high: newsImageHeightConstraint)
        }
    }
}
