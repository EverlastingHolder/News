import UIKit
import Combine
import CoreData

class NewsTableViewController: UITableViewController {
    var viewModel: NewsTableViewModel
    
    private var page = 1
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: NewsTableViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.viewModel = .init(news: .init(status: "", totalResults: 0, articles: []))
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    private func bindViewModel() {
        viewModel.$news
            .sink { [unowned self] news in
                tableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.news.articles.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let news = viewModel.news.articles[indexPath.row]
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detail = storyboard.instantiateViewController(identifier: "NewsDetailViewController") as! NewsDetailViewController
        detail.newsModel = news
        detail.isFavorite = (CoreDataService.shared.findNews(news) != nil)
        
        self.navigationController?.pushViewController(detail, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell", for: indexPath) as! NewsTableViewCell
        
        let news = viewModel.news.articles[indexPath.row]
        
        if news.urlToImage == nil {
            cell.newsImageHeightConstraint.priority = .defaultLow
            cell.newsImageHeightLowConstraint.priority = .defaultHigh
        } else {
            cell.newsImageHeightLowConstraint.priority = .defaultLow
            cell.newsImageHeightConstraint.priority = .defaultHigh
        }
        
        cell.setData(cellType: .init(newsModel: news))
        
        if indexPath.row == viewModel.news.articles.count - 1 {
            page += 1
            viewModel.getNews(page: page)
        }
        return cell
    }
}
