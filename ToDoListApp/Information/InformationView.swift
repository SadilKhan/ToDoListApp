import SwiftUI

/// View for adding Title and Description of a to-do item
///
///
/// ```
/// struct InformationView: View {
///     var body: some View {
///         VStack {
///             TitleTextField()
///             DescriptionField()
///        }
///    }
///}
/// ```
///
struct InformationView: View {
    @State var titleText: String = ""
    @State var descriptionText:String = ""
    var body: some View {
        VStack {
            // Title Text
            TitleTextField(titleText: $titleText)
            // Description Field
            DescriptionField(descriptionText: $descriptionText)
            // Save Button
            Button {
                
            } label: {
                Text("Save")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue.cornerRadius(10))
                    .padding()
                    .foregroundColor(.white)
            }

            
        }
    }
}



struct InformationView_Previews: PreviewProvider {
    static var previews: some View {
        InformationView()
    }
}
