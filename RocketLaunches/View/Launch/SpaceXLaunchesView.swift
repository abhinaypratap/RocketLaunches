import SwiftUI

struct SpaceXLaunchesView: View {
    //  @Environment(\.managedObjectContext) var viewContext
    @State var isCompleted = false
    let launchListTitle: String
    let launchList: SpaceXLaunchList

    // Technique One
    //  var launchesFetchRequest: FetchRequest<SpaceXLaunch>
    //  var launches: FetchedResults<SpaceXLaunch> {
    //    launchesFetchRequest.wrappedValue
    //  }

    let sortTypes = [
        (name: "Name", descriptors: [SortDescriptor(\SpaceXLaunch.name, order: .forward)]),
        (name: "Viewed", descriptors: [SortDescriptor(\SpaceXLaunch.isViewed, order: .forward)])
    ]

    // Technique Two
    @FetchRequest(
        sortDescriptors: [],
        animation: .default)
    var launches: FetchedResults<SpaceXLaunch>

    var body: some View {
        VStack {
            List {
                Section {
                    ForEach(launches, id: \.self) { launch in
                        NavigationLink(destination: SpaceXLaunchDetailView(launch: launch)) {
                            LaunchStatusView(isViewed: launch.isViewed)
                            Text("\(launch.name ?? "")")
                        }
                    }
                }
            }
            .background(Color.white)
        }
        .navigationBarTitle(Text(launchListTitle))
        .onAppear() {
            launches.nsPredicate = NSPredicate(format: "ANY spaceXList.title == %@", launchListTitle)
            launches.sortDescriptors = sortTypes[0].descriptors
        }
        .toolbar {
            Menu {
                ForEach(0..<sortTypes.count, id: \.self) { index in
                    let sortType = sortTypes[index]
                    Button(action: {
                        launches.sortDescriptors = sortType.descriptors
                    }, label: {
                        Text(sortType.name)
                    })
                }
            }
        label: {
            Image(systemName: "line.3.horizontal.decrease.circle.fill")
        }
        }
    }

    init(launchList: SpaceXLaunchList) {
        self.launchList = launchList
        self.launchListTitle = launchList.title ?? "No Title Found"

        // Technique One
        ////    let listPredicate = NSPredicate(format: "%K == %@", "list.title", launchListTitle)
        //    let listPredicate = NSPredicate(format: "ANY spaceXList.title == %@", launchListTitle)
        ////    let isViewedPredicate = NSPredicate(format: "%K == %@", "isViewed", NSNumber(value: false))
        //    let combinedPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [listPredicate/*, isViewedPredicate*/])
        //
        ////    let prioritySortDescriptor = NSSortDescriptor(key: "priority", ascending: false)
        ////    let dateSortDescriptor = NSSortDescriptor(key: "launchDate", ascending: false)
        //
        //    self.launchesFetchRequest = FetchRequest(
        //      entity: SpaceXLaunch.entity(),
        //      sortDescriptors: [/*prioritySortDescriptor, dateSortDescriptor*/],
        //      predicate: combinedPredicate)
    }
}

struct SpaceXLaunchesView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let newLaunchList = SpaceXLaunchList(context: context)
        newLaunchList.title = "Preview List"
        return SpaceXLaunchesView(launchList: newLaunchList)
    }
}
