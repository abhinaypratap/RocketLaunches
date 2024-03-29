import SwiftUI
import SafariServices
import AVKit

struct SpaceXLaunchDetailView: View {
    @State private var webcastPopupVisible = false
    let launch: SpaceXLaunch
    let launchName: String?
    let launchNotes: String?
    let launchDate: Date?
    let isViewed: Bool?
    let allLists: [RocketLaunchList]
    var webcastURL: URL?
    var imageURL: URL?

    init(launch: SpaceXLaunch) {
        self.launch = launch
        self.launchName = launch.name
        self.launchNotes = launch.notes
        self.launchDate = launch.launchDate
        self.isViewed = launch.isViewed
        self.allLists = PersistenceController.getAllLists()
        if let links = launch.links,
           let webcast = links.webcast {
            webcastURL = URL(string: webcast)
        }
        if let links = launch.links,
           let patch = links.patch,
           let smallImage = patch["small"] {
            imageURL = URL(string: smallImage)
        }
    }

    var body: some View {
        return VStack {
            if let imageURL = imageURL {
                AsyncImage(url: imageURL) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image.resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: 300, maxHeight: 100)
                    case .failure:
                        Image(systemName: "photo")
                    @unknown default:
                        EmptyView()
                    }
                }
            }
            Form {
                if let webcastURL = webcastURL {
                    Section("Webcast") {
                        Button(action: {
                            self.webcastPopupVisible.toggle()
                        }, label: {
                            Text("Play Video")
                        })
                        .sheet(isPresented: $webcastPopupVisible) {
                            WebcastView(url: webcastURL)
                                .navigationTitle("Mission Webcast")
                        }
                    }
                }
                if let launchDateUTC = launch.dateUtc {
                    DetailsSection(title: "Launch Date (UTC)", value: launchDateUTC)
                }
                DetailsSection(title: "Flight Number", value: "\(launch.flightNumber)")
                RedditLinks(launch: launch)
                Button(action: {
                    launch.isViewed = true
                }, label: {
                    Text("Mark as Viewed")
                        .foregroundColor(Color.red)
                })
            }
        }
        .navigationTitle(launch.name ?? "No Name")
        .toolbar {
            Menu {
                ForEach(allLists, id: \.title) { list in
                    Button(action: {
                        launch.addToList(list)
                    }, label: {
                        Text(list.title ?? "No list name")
                    })
                }
            }
        label: {
            Image(systemName: "heart")
        }
        .disabled(allLists.isEmpty)
        }
    }
}

struct WebcastView: UIViewControllerRepresentable {
    var url: URL

    func makeUIViewController(context: Context) -> SFSafariViewController {
        SFSafariViewController(url: url)
    }

    func updateUIViewController(_ uiView: SFSafariViewController, context: Context) {
    }
}

struct DetailsSection: View {
    let title: String
    let value: String

    var body: some View {
        Section(title) {
            Text(value)
        }
    }
}

struct RedditLinks: View {
    let launch: SpaceXLaunch

    var body: some View {
        Section("Reddit Links") {
            if let redditLinks = launch.links?.reddit {
                if let launchLink = redditLinks["launch"], !launchLink.isEmpty {
                    DetailsLinkSection(linkTitle: "Launch", value: launchLink)
                }
                if let launchLink = redditLinks["campaign"], !launchLink.isEmpty {
                    DetailsLinkSection(linkTitle: "Campaign", value: launchLink)
                }
                if let launchLink = redditLinks["recovery"], !launchLink.isEmpty {
                    DetailsLinkSection(linkTitle: "Recovery", value: launchLink)
                }
            }
        }
    }
}

struct DetailsLinkSection: View {
    let linkTitle: String
    let value: String

    var body: some View {
        // swiftlint:disable:next force_unwrapping
        Link(destination: URL(string: value)!) {
            Text(linkTitle)
        }
    }
}

struct SpaceXLaunchDetailView_Previews: PreviewProvider {
    static var previews: some View {
        if let launch = PersistenceController.getTestLaunch() {
            NavigationView {
                SpaceXLaunchDetailView(launch: launch)
            }
        } else {
            Text("Problem fetching data")
        }
    }
}
