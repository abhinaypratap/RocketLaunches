import SwiftUI

struct ListCreateView: View {
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.dismiss) var dismiss

    @State var text: String = ""

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                HStack {
                    Spacer()
                    CircularImageView(color: .red)
                    Spacer()
                }
                .padding([.top, .bottom])
                HStack {
                    Text("Enter a list title")
                    Spacer()
                }
                .padding([.leading, .trailing])
                TextField("Title", text: $text)
                    .padding()
                    .background(
                        Color(red: 231 / 255, green: 234 / 255.0, blue: 237 / 255.0)
                    )
                    .cornerRadius(10)
                    .padding()
                Spacer()
            }
            .navigationBarTitle(Text("Create Launch"), displayMode: .inline)
            .navigationBarItems(
                leading: Button("Close") {
                    dismiss()
                },
                trailing: Button("Save") {
                    if !self.text.isEmpty {
                        RocketLaunchList.create(withTitle: self.text, in: self.viewContext)
                        dismiss()
                    }
                }
            )
        }
    }
}

struct ListCreateView_Previews: PreviewProvider {
    static var previews: some View {
        ListCreateView(text: "")
    }
}
