import Combine
import CoreData

class FavoriteViewModel: ObservableObject {
    @Published var news: APIResult<[News]> = .loading
    
    func getNews() {
        news = fetchNews()
    }
    
    private func fetchNews() -> APIResult<[News]> {
        let newsFetch: NSFetchRequest<News> = News.fetchRequest()
        let sortByDate = NSSortDescriptor(key: #keyPath(News.addDate), ascending: false)
        newsFetch.sortDescriptors = [sortByDate]
        do {
            let managedContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
            let results = try managedContext.fetch(newsFetch)
            return .success(results)
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
            return .error
        }
    }
}
