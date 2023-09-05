import UIKit
import Combine

class NewsViewController: UIViewController {
    private var viewModel: NewsViewModel = .init()
    private var cancellables = Set<AnyCancellable>()
    private let child = SpinnerViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    private func bindViewModel() {
        viewModel.$status
            .sink { [unowned self] status in
                switch status {
                case .loading:
                    addChild(child)
                    child.view.frame = view.frame
                    view.addSubview(child.view)
                    child.didMove(toParent: self)
                case .success(_):
                    child.willMove(toParent: nil)
                    child.view.removeFromSuperview()
                    child.removeFromParent()
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let tableView = storyboard.instantiateViewController(identifier: "NewsTableViewController") as! NewsTableViewController
                    tableView.viewModel = viewModel
                    tableView.news = viewModel.news
                    
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
