import SwiftUI

struct LaunchDetailView: View {
    @Environment(\.managedObjectContext) var viewContext
    let launch: RocketLaunch
    let launchName: String?
    let launchNotes: String?
    let launchDate: Date?
    let isViewed: Bool?
    var attachment: UIImage?
    let allLists: [RocketLaunchList]

    init(launch: RocketLaunch) {
        self.launch = launch
        self.launchName = launch.name
        self.launchNotes = launch.notes
        self.launchDate = launch.launchDate
        self.isViewed = launch.isViewed

        if let attachment = launch.attachment {
            self.attachment = UIImage(data: attachment)
        }
        self.allLists = PersistenceController.getAllLists()
    }

    var body: some View {
        Form {
            Section("Notes") {
                Text(launchNotes ?? "No Notes")
            }
            if let launchDate = launchDate {
                Section("Launch Date") {
                    Text(launchDate.formatted())
                }
            }
            if let attachment = attachment {
                Section {
                    Image(uiImage: attachment)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
            }
            Section {
                Button("Mark as Viewed") {
                    self.launch.isViewed = true
                    do {
                        try viewContext.save()
                    } catch {
                        print("Error marking launch as viewed \(error)")
                    }
                }
            }
        }
        .navigationTitle(self.launchName ?? "Sample Launch")
        .background(Color(.systemGroupedBackground))
    }
}

struct LaunchDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let newLaunch = RocketLaunch(context: context)
        newLaunch.name = "Some launch"
        newLaunch.notes = "Here are the notes"
        newLaunch.launchDate = Date()
        return LaunchDetailView(launch: newLaunch)
    }
}
