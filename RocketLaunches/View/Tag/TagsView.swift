import SwiftUI

struct TagsView: View {
    @Environment(\.managedObjectContext) var viewContext
    let tags: [Tag]

    var body: some View {
        NavigationView {
            VStack {
                List {
                    Section {
                        ForEach(tags, id: \.self) { tag in
                            Text(tag.title ?? "")
                        }
                    }
                }
            }
            .navigationBarTitle(Text("Tags"))
        }
    }
}

struct TagsView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let tag = Tag(context: context)
        tag.title = "Test"
        return TagsView(tags: [tag])
    }
}
