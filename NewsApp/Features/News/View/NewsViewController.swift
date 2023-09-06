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
                    addChildView(child)
                case .success(let model):
                    removeProgressView()
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let tableView = storyboard.instantiateViewController(identifier: "NewsTableViewController") as! NewsTableViewController
                    tableView.viewModel = .init(news: model)
                    addChildView(tableView)
                    
                default:
                    removeProgressView()
                }
            }
            .store(in: &cancellables)
    }
    
    private func removeProgressView() {
        child.willMove(toParent: nil)
        child.view.removeFromSuperview()
        child.removeFromParent()
    }
    
    private func addChildView(_ viewController: UIViewController) {
        addChild(viewController)
        viewController.view.frame = view.frame
        view.addSubview(viewController.view)
        viewController.didMove(toParent: self)
    }
}
