import SwiftUI
import CoreData

struct LaunchCreateView: View {
    // MARK: - Environment -
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var viewContext

    // MARK: - State -
    @State var name: String = ""
    @State var notes: String = ""
    @State var isViewed = false
    @State var launchDate = Date()
    @State var launchpad: String = ""
    @State var tags: String = ""
    @State var showImagePicker = false
    @State var attachment: UIImage?

    let launchList: RocketLaunchList

    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Title", text: $name)
                    TextField("Launch Pad", text: $launchpad)
                    TextField("Notes", text: $notes)
                }
                Section {
                    TextField("Tags", text: $tags)
                }
                Section {
                    DatePicker(selection: $launchDate, displayedComponents: .date) {
                        Text("Date")
                    }
                }
                Section {
                    if let attachment = attachment {
                        Image(uiImage: attachment)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } else {
                        Button("Pick Image") {
                            showImagePicker.toggle()
                        }
                    }
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarTitle(Text("Create Event"), displayMode: .inline)
            .navigationBarItems(trailing:
                                    Button(action: {
                let tags = Set(self.tags.split(separator: ",").map {
                    Tag.fetchOrCreateWith(title: String($0), in: self.viewContext)
                })
                RocketLaunch.createWith(
                    name: self.name,
                    notes: self.notes,
                    launchDate: self.launchDate,
                    isViewed: false,
                    launchpad: self.launchpad,
                    attachment: self.attachment,
                    tags: tags,
                    in: self.launchList,
                    using: self.viewContext)
                dismiss()
            }, label: {
                Text("Save")
                    .fontWeight(.bold)
            })
            )
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(image: $attachment)
            }
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.dismiss) private var dismiss
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Binding var image: UIImage?

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator

        return imagePicker
    }

    func updateUIViewController(
        _ uiViewController: UIImagePickerController,
        context: UIViewControllerRepresentableContext<ImagePicker>
    ) {
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(
            _ picker: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
        ) {
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                parent.image = image
            }
            parent.dismiss()
        }
    }
}

struct LaunchCreateView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let newLaunchList = RocketLaunchList(context: context)
        newLaunchList.title = "Preview List"
        return LaunchCreateView(launchList: newLaunchList)
            .environment(\.managedObjectContext, context)
    }
}
