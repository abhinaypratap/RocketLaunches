import Foundation
import CoreData

extension Tag {
  @nonobjc
  public class func fetchRequest() -> NSFetchRequest<Tag> {
    return NSFetchRequest<Tag>(entityName: "Tag")
  }

  static func fetchOrCreateWith(
    title: String,
    in context: NSManagedObjectContext
  ) -> Tag {
    let request: NSFetchRequest<Tag> = fetchRequest()
    let predicate = NSPredicate(format: "%K == %@", "title", title.lowercased())
    request.predicate = predicate

    do {
      let results = try context.fetch(request)

      if let tag = results.first {
        return tag
      } else {
        let tag = Tag(context: context)
        tag.title = title.lowercased()
        return tag
      }
    } catch {
      fatalError("Error fetching tag")
    }
  }

  @NSManaged public var title: String?
  @NSManaged public var launches: Set<RocketLaunch>

  @objc var launchCount: Int {
    willAccessValue(forKey: "launches")
    let count = launches.count
    didAccessValue(forKey: "launches")
    return count
  }
}

// MARK: Generated accessors for launches
extension Tag {
  @objc(addLaunchesObject:)
  @NSManaged public func addToLaunches(_ value: RocketLaunch)

  @objc(removeLaunchesObject:)
  @NSManaged public func removeFromLaunches(_ value: RocketLaunch)

  @objc(addLaunches:)
  @NSManaged public func addToLaunches(_ values: NSSet)

  @objc(removeLaunches:)
  @NSManaged public func removeFromLaunches(_ values: NSSet)
}

extension Tag: Identifiable {
}
