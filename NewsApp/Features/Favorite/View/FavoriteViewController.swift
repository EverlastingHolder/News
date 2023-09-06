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
                    addChildView(child)
                case .success(let model):
                    removeProgressView()
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let tableView = storyboard.instantiateViewController(identifier: "FavoriteTableViewController") as! FavoriteTableViewController
                    tableView.news = model
                    
                    addChildView(tableView)
                case .error:
                    removeProgressView()
                case .empty:
                    removeProgressView()
                    addTitle()
                }
            }
            .store(in: &cancellables)
    }
    
    private func addTitle() {
        let label = UILabel()
        label.text = "Нет избранных новостей"
        label.font = .systemFont(ofSize: 16)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(label)
        
        label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
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
