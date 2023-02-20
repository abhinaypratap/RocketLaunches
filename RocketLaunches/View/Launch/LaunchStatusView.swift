import SwiftUI

struct LaunchStatusView: View {
    var isViewed: Bool

    var body: some View {
        Circle()
            .padding(4)
            .overlay(
                Circle()
                    .stroke(isViewed ? .green : .red, lineWidth: 2)
            )
            .foregroundColor(isViewed ? .green : .clear)
            .frame(width: 20, height: 20)
    }
}

struct LaunchStatusView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchStatusView(isViewed: true).previewLayout(.fixed(width: 300, height: 70))
    }
}
