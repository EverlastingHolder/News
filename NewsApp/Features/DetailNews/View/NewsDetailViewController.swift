import UIKit
import Combine

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
    
    private let viewModel: NewsDetailViewModel
    private var cancellable = Set<AnyCancellable>()
    
    init?(viewModel: NewsDetailViewModel, coder: NSCoder) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }
    
    @available(*, unavailable, renamed: "init(product:coder:)")
    required init?(coder: NSCoder) {
        fatalError("Invalid way of decoding this class")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        bindViewModel()
    }
    
    @IBAction private func actionFavoriteButton(_ sender: UIBarButtonItem) {
        viewModel.actionFavoriteButton(image: newsImage.image?.pngData())
    }
    
    private func bindViewModel() {
        viewModel.$isFavorite
            .sink { [unowned self] in
                setImageButton($0)
            }
            .store(in: &cancellable)
    }
    
    private func setUpLink () {
        let attributedString = NSMutableAttributedString.init(string: linkLabel.text ?? "")
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range:
            NSRange.init(location: 0, length: attributedString.length)
        )
        linkLabel.attributedText = attributedString
        linkLabel.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(openLink))
        linkLabel.addGestureRecognizer(tap)
    }
    
    @objc private func openLink() {
        viewModel.openLink()
    }
    
    private func setImageButton(_ isFavorite: Bool) {
        if !isFavorite {
            favoriteNavigationButton.image = .init(systemName: "star")
            return
        }
        favoriteNavigationButton.image = .init(systemName: "star.fill")
    }
    
    private func setUp() {
        linkLabel.text = viewModel.newsModel.url
        titleLabel.text = viewModel.newsModel.title
        contentLabel.text = viewModel.newsModel.content
        creatorLabel.text = viewModel.newsModel.author
        publishedDateLabel.text = viewModel.newsModel.publishedAt
        
        newsImage.layer.cornerRadius = 12
        
        setUpLink()
        
        if let data = viewModel.newsModel.image, let image = UIImage(data: data) {
            low.priority = .defaultLow
            high.priority = .defaultHigh
            newsImage.image = image
        } else {
            Task {
                await newsImage.loadImage(urlString: viewModel.newsModel.urlToImage, low: low, high: high)
            }
        }
    }
}
