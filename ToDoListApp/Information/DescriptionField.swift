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
        VStack{
            // Title Text
            Text("Description")
                .font(.title)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity,alignment: .leading)
                .padding(.horizontal,10)
            // Text Editor for adding title
            TextEditor(text: $descriptionText)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray)
                }
                .padding()
        }
    }
}
