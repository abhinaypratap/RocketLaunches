import CoreData
import SwiftUI
import UIKit

extension RocketLaunch {
    // swiftlint:disable:next function_parameter_count
    static func createWith(
        name: String,
        notes: String,
        launchDate: Date,
        isViewed: Bool,
        launchpad: String,
        attachment: UIImage?,
        tags: Set<Tag> = [],
        in list: RocketLaunchList,
        using managedObjectContext: NSManagedObjectContext
    ) {
        let launch = RocketLaunch(context: managedObjectContext)
        launch.name = name
        launch.notes = notes
        launch.launchDate = launchDate
        launch.isViewed = isViewed
        launch.launchpad = launchpad
        launch.attachment = attachment?.jpegData(compressionQuality: 1) ?? Data()
        launch.tags = tags
        launch.addToList(list)

        do {
            try managedObjectContext.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }

    static func basicFetchRequest() -> FetchRequest<RocketLaunch> {
        return FetchRequest<RocketLaunch>(entity: RocketLaunch.entity(), sortDescriptors: [])
    }

    static func sortedFetchRequest() -> FetchRequest<RocketLaunch> {
        let launchDateSortDescriptor = NSSortDescriptor(key: "launchDate", ascending: true)
        return FetchRequest(entity: RocketLaunch.entity(), sortDescriptors: [launchDateSortDescriptor])
    }

    static func fetchRequestSortedByNameAndLaunchDate() -> FetchRequest<RocketLaunch> {
        let nameSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        let launchDateSortDescriptor = NSSortDescriptor(key: "launchDate", ascending: true)
        return FetchRequest(
            entity: RocketLaunch.entity(),
            sortDescriptors: [nameSortDescriptor, launchDateSortDescriptor]
        )
    }

    static func unViewedLaunchesFetchRequest() -> FetchRequest<RocketLaunch> {
        let nameSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        let launchDateSortDescriptor = NSSortDescriptor(key: "launchDate", ascending: false)
        let isViewedPredicate = NSPredicate(format: "%K == %@", "isViewed", NSNumber(value: false))
        return FetchRequest(
            entity: RocketLaunch.entity(),
            sortDescriptors: [nameSortDescriptor, launchDateSortDescriptor],
            predicate: isViewedPredicate)
    }

    static func launches(in list: RocketLaunchList) -> FetchRequest<RocketLaunch> {
        let nameSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        let launchDateSortDescriptor = NSSortDescriptor(key: "launchDate", ascending: false)
        let listPredicate = NSPredicate(format: "%K == %@", "list.title", list.title!)
        let isViewedPredicate = NSPredicate(format: "%K == %@", "isViewed", NSNumber(value: false))
        let combinedPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [listPredicate, isViewedPredicate])
        return FetchRequest(
            entity: RocketLaunch.entity(),
            sortDescriptors: [nameSortDescriptor, launchDateSortDescriptor],
            predicate: combinedPredicate)
    }

    @NSManaged public var name: String?
    @NSManaged public var isViewed: Bool
    @NSManaged public var launchDate: Date?
    @NSManaged public var launchpad: String?
    @NSManaged public var notes: String?
    @NSManaged public var list: Set<RocketLaunchList>
    @NSManaged var tags: Set<Tag>?
    @NSManaged public var attachment: Data?
}

// MARK: Generated accessors for list
extension RocketLaunch {
    @objc(addListObject:)
    @NSManaged public func addToList(_ value: RocketLaunchList)

    @objc(removeListObject:)
    @NSManaged public func removeFromList(_ value: RocketLaunchList)

    @objc(addList:)
    @NSManaged public func addToList(_ values: NSSet)

    @objc(removeList:)
    @NSManaged public func removeFromList(_ values: NSSet)
}

extension RocketLaunch: Identifiable {
}
