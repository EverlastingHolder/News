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

}

extension News : Identifiable {

}
