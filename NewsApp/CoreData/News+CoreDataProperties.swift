import Foundation
import CoreData
import UIKit

extension News {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<News> {
        return NSFetchRequest<News>(entityName: "News")
    }

    @NSManaged public var id: Int16
    @NSManaged public var title: String?
    @NSManaged public var content: String?
    @NSManaged public var image: Data?
    @NSManaged public var publishedDate: String?
    @NSManaged public var addDate: Date?
    @NSManaged public var author: String?
    @NSManaged public var newsDescription: String?
}

extension News : Identifiable {

}
