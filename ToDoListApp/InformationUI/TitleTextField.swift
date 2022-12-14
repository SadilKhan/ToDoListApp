import SwiftUI

/// View for adding Title text
///
/// Contains a Text view and Text Field View
///
struct TitleTextField: View {
    @Binding var defaultTitleText: String
    @Binding var titleText: String
    var body: some View {
        VStack {
            // Title Text
            Text("Title")
                .font(.title2)
                .fontWeight(.medium)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 10)
            // TextField for adding title
            TextField(defaultTitleText, text: $titleText)
                .padding()
                .background(.thinMaterial)
                .cornerRadius(30)
                .padding(.horizontal, 10)
        }
    }
}
