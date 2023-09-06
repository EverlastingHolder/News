import UIKit
import Combine
import CoreData

class NewsTableViewController: UITableViewController {
    private let viewModel: NewsTableViewModel
    private var cancellables = Set<AnyCancellable>()
    private var news: ResultModel = .init(status: "", totalResults: 0, articles: []) {
        didSet {
            tableView.reloadData()
        }
    }
    
    
    init?(viewModel: NewsTableViewModel, coder: NSCoder) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }
    
    @available(*, unavailable, renamed: "init(product:coder:)")
    required init?(coder: NSCoder) {
        fatalError("Invalid way of decoding this class")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    private func bindViewModel() {
        viewModel.$news
            .sink { news in
                self.news = news
            }
            .store(in: &cancellables)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.articles.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let news = news.articles[indexPath.row]
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detail = storyboard.instantiateViewController(identifier: "NewsDetailViewController") { coder in
            NewsDetailViewController(viewModel: .init(isFavorite: (CoreDataService.shared.findNews(news) != nil), newsModel: news), coder: coder)
        }
        
        self.navigationController?.pushViewController(detail, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell", for: indexPath) as! NewsTableViewCell
        
        let news = news.articles[indexPath.row]
        
        if news.urlToImage == nil {
            cell.newsImageHeightConstraint.priority = .defaultLow
            cell.newsImageHeightLowConstraint.priority = .defaultHigh
        } else {
            cell.newsImageHeightLowConstraint.priority = .defaultLow
            cell.newsImageHeightConstraint.priority = .defaultHigh
        }
        
        cell.setData(cellType: .init(newsModel: news))
        
        if indexPath.row == viewModel.news.articles.count - 1 {
            viewModel.getNews()
        }
        
        return cell
    }
}
