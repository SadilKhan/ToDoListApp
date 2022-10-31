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
    @State var defaultTitleText: String
    @State var titleText: String
    @State var descriptionText: String
    @State var date: String
    var id: String = ""
    @EnvironmentObject var itemDataBase: ItemDB
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        VStack {
            // Title Text
            TitleTextField(defaultTitleText: $defaultTitleText, titleText: $titleText)
            // Description Field
            DescriptionField(descriptionText: $descriptionText)
            // Save Button
            Button {
                if itemDataBase.allItems[self.id] != nil {
                    itemDataBase.allItems[self.id]=ToDoItem(titleText: self.titleText, descriptionText: self.descriptionText, date: self.date)
                } else {
                    itemDataBase.appendItem(ToDoItem(titleText: titleText, descriptionText: descriptionText, date: date))
                }
                dismiss()
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

    init() {
        self._defaultTitleText=State(initialValue: "Write Something Here")
        self._titleText = State(initialValue: "")
        self._descriptionText = State(initialValue: "")
        self._date = State(initialValue: "")
    }

    init(key: String, item: ToDoItem) {
        self._defaultTitleText = State(initialValue: item.getTitleText())
        self._titleText = State(initialValue: item.getTitleText())
        self._descriptionText = State(initialValue: item.getDecriptionText())
        self._date=State(initialValue: item.getDate())
        self.id = key
    }

}

struct InformationView_Previews: PreviewProvider {
    static var previews: some View {
        InformationView(key: "6", item: ToDoItem(titleText: "Grocery", descriptionText: "Heyyy", date: "22-19"))
    }
}
