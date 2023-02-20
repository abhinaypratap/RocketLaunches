import SwiftUI

struct LaunchesView: View {
    @State var isShowingCreateModal = false
    @State var isShowingTagsModal = false
    @State var activeSortIndex = 0
    let launchListTitle: String
    @FetchRequest(
        sortDescriptors: [],
        animation: .default)
    var launches: FetchedResults<RocketLaunch>

    let launchList: RocketLaunchList
    var tags: [Tag] {
        let tagsSet = launchList.launches.compactMap { $0.tags }.reduce(Set<Tag>(), { result, tags in
            var result = result
            result.formUnion(tags)
            return result
        })
        return Array(tagsSet)
    }

    let sortTypes = [
        (name: "Name", descriptors: [SortDescriptor(\RocketLaunch.name, order: .forward)]),
        (name: "LaunchDate", descriptors: [SortDescriptor(\RocketLaunch.launchDate, order: .forward)])
    ]

    init(launchList: RocketLaunchList) {
        self.launchList = launchList
        self.launchListTitle = launchList.title ?? "No Title Found"
    }

    var body: some View {
        VStack {
            List {
                Section {
                    ForEach(launches, id: \.self) { launch in
                        NavigationLink(destination: LaunchDetailView(launch: launch)) {
                            HStack {
                                LaunchStatusView(isViewed: launch.isViewed)
                                Text("\(launch.name ?? "")")
                                Spacer()
                            }
                        }
                    }
                }
            }
            .background(Color.white)
            HStack {
                NewLaunchButton(isShowingCreateModal: $isShowingCreateModal, launchList: self.launchList)
                Spacer()
            }
            .padding(.leading)
        }
        .navigationBarTitle(Text("Launches"))
        .navigationBarItems(trailing:
                                Button("Tags") {
            self.isShowingTagsModal.toggle()
        }
            .sheet(isPresented: self.$isShowingTagsModal, content: {
                TagsView(tags: tags)
            })
        )
        .onChange(of: activeSortIndex) { _ in
            launches.sortDescriptors = sortTypes[activeSortIndex].descriptors
        }
        .toolbar {
            Menu(content: {
                Picker(
                    selection: $activeSortIndex,
                    content: {
                        ForEach(0..<sortTypes.count, id: \.self) { index in
                            let sortType = sortTypes[index]
                            Text(sortType.name)
                        }
                    },
                    label: {}
                )
            }, label: {
                Image(systemName: "line.3.horizontal.decrease.circle.fill")
            })
        }
    }
}

struct LaunchesView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let newLaunchList = RocketLaunchList(context: context)
        newLaunchList.title = "Preview List"
        return LaunchesView(launchList: newLaunchList).environment(\.managedObjectContext, context)
    }
}

struct NewLaunchButton: View {
    @Binding var isShowingCreateModal: Bool
    let launchList: RocketLaunchList

    var body: some View {
        Button(
            action: { self.isShowingCreateModal.toggle() },
            label: {
                Image(systemName: "plus.circle.fill")
                    .foregroundColor(.red)
                Text("New Launch")
                    .font(.headline)
                    .foregroundColor(.red)
            })
        .sheet(isPresented: $isShowingCreateModal) {
            LaunchCreateView(launchList: launchList)
        }
    }
}
