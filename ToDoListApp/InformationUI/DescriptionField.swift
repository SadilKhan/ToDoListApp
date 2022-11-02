import SwiftUI

/// Add description for the title
///
/// Contains a Text View and A Text Editor View
///
struct DescriptionField: View {
    @Binding var descriptionText: String
    var body: some View {
        // Sadil: Working Copy - things to do
        // 1. Add markdown support
        VStack {
            // Title Text
            Text("Note")
                .font(.title2)
                .fontWeight(.medium)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 10)
            // Text Editor for adding title
            TextEditor(text: $descriptionText)
                .padding(10)
                .overlay {
                RoundedRectangle(cornerRadius: 30)
                    .stroke(ColorsDB().strokeColorDescriptionField)
            }
                .padding()

        }
    }
}
