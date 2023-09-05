import UIKit
import Combine

class NewsTableViewController: UITableViewController {
    var viewModel: NewsViewModel
    var news: ResultModel {
        didSet {
            tableView.reloadData()
        }
    }
    
    private var page = 1
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: NewsViewModel, news: ResultModel) {
        self.viewModel = viewModel
        self.news = news
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.viewModel = .init()
        self.news = .init(status: "", totalResults: 0, articles: [])
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    private func bindViewModel() {
        viewModel.$news
            .sink { [unowned self] news in
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
        
        if indexPath.row == self.news.articles.count - 1 {
            page += 1
            viewModel.getNews(page: page)
        }
        return cell
    }
}
