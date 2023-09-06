import UIKit
import Combine

class FavoriteTableViewController: UITableViewController {
    
    private let viewModel: FavoriteTableViewModel
    private var cancellable = Set<AnyCancellable>()
    
    init?(viewModel: FavoriteTableViewModel, coder: NSCoder) {
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
            .sink { [unowned self] _ in 
                tableView.reloadData()
            }
            .store(in: &cancellable)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.news.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let news = viewModel.news[indexPath.row]
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detail = storyboard.instantiateViewController(identifier: "NewsDetailViewController") { coder in
            NewsDetailViewController(viewModel: .init(isFavorite: true, newsModel: .init(news: news)), coder: coder)
        }
        
        self.navigationController?.pushViewController(detail, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell", for: indexPath) as! NewsTableViewCell
        
        let news = viewModel.news[indexPath.row]
        
        cell.setData(cellType: .init(news: news))
        
        return cell
    }
}
