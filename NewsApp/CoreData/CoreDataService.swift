import CoreData

class CoreDataService {
    private let newsFetch: NSFetchRequest<News> = News.fetchRequest()
    private let sortByDate = NSSortDescriptor(key: #keyPath(News.addDate), ascending: false)
    private let managedContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
    
    static let shared = CoreDataService()
    
    func findNews(_ item: NewsModel) -> News? {
        fetchNews()?.first(where: { item.content == $0.content && item.publishedAt == $0.publishedDate && item.url == $0.newsLink })
    }
    
    func fetchNews() -> [News]? {
        newsFetch.sortDescriptors = [sortByDate]
        do {
            let results = try managedContext.fetch(newsFetch)
            return results
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
            return nil
        }
    }
    
    func removeNews(_ item: News) {
        AppDelegate.sharedAppDelegate.coreDataStack.managedContext.delete(item)
        AppDelegate.sharedAppDelegate.coreDataStack.saveContext()
    }
    
    func addFavoriteNews(newsModel: NewsModel, image: Data?) {
        let news = News(context: managedContext)
        news.setValue(image, forKey: #keyPath(News.image))
        news.setValue(Date(), forKey: #keyPath(News.addDate))
        news.setValue(newsModel.title, forKey: #keyPath(News.title))
        news.setValue(newsModel.url, forKey: #keyPath(News.newsLink))
        news.setValue(newsModel.author, forKey: #keyPath(News.author))
        news.setValue(newsModel.content, forKey: #keyPath(News.content))
        news.setValue(newsModel.publishedAt, forKey: #keyPath(News.publishedDate))
        news.setValue(newsModel.description, forKey: #keyPath(News.newsDescription))
        AppDelegate.sharedAppDelegate.coreDataStack.saveContext()
    }
}
