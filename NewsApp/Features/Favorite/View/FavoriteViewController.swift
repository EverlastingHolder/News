import UIKit
import Combine

class FavoriteViewController: UIViewController {
    private var viewModel: FavoriteViewModel = .init()
    private var cancellables = Set<AnyCancellable>()
    private let child = SpinnerViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getNews()
    }
    
    private func bindViewModel() {
        viewModel.$news
            .sink { [unowned self] status in
                switch status {
                case .loading:
                    addChild(child)
                    child.view.frame = view.frame
                    view.addSubview(child.view)
                    child.didMove(toParent: self)
                case .success(let model):
                    child.willMove(toParent: nil)
                    child.view.removeFromSuperview()
                    child.removeFromParent()
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let tableView = storyboard.instantiateViewController(identifier: "FavoriteTableViewController") as! FavoriteTableViewController
                    tableView.news = model
                    
                    addChild(tableView)
                    tableView.view.frame = view.frame
                    view.addSubview(tableView.view)
                    tableView.didMove(toParent: self)
                    
                case .error:
                    child.willMove(toParent: nil)
                    child.view.removeFromSuperview()
                    child.removeFromParent()
                }
            }
            .store(in: &cancellables)
    }
}
