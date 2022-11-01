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
    // MARK: PROPERTIES
    @State var defaultTitleText: String
    @State var titleText: String
    @State var descriptionText: String
    @State var selectedDate: Date
    @State var typeSelected: String
    @State var showAlert: Bool = false
    var id: String = ""
    @EnvironmentObject var itemDataBase: ItemDB
    @Environment(\.dismiss) private var dismiss

    // MARK: BODY
    var body: some View {
        VStack {
            // Title Text
            TitleTextField(defaultTitleText: $defaultTitleText, titleText: $titleText)
            // Description Field
            DescriptionField(descriptionText: $descriptionText)
            //Type Field
            PickerField(selection: $typeSelected)
            // Date Field
            DateField(selectedDate: $selectedDate)
            // Save Button
            Button {
                if self.titleText.count > 1 {
                    if itemDataBase.allItems[self.id] != nil {
                        let _ = print(descriptionText)
                        itemDataBase.updateItem(self.id, item: ToDoItem(titleText: self.titleText, descriptionText: self.descriptionText, type: self.typeSelected, date: self.selectedDate))
                    } else {
                        itemDataBase.appendItem(ToDoItem(titleText: titleText,
                            descriptionText: descriptionText, type: typeSelected,
                            date: selectedDate))
                    }
                    showAlert = false
                    dismiss()

                } else {
                    showAlert = true
                }
            } label: {
                Text("Save")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue.cornerRadius(10))
                    .padding()
                    .foregroundColor(.white)
            }
                .alert(isPresented: $showAlert) {
                    getAlert()
            }
        }
    }

    // MARK: CONSTRUCTOR

    init() {
        self._defaultTitleText = State(initialValue: "Write Something Here")
        self._titleText = State(initialValue: "")
        self._descriptionText = State(initialValue: "")
        self._selectedDate = State(initialValue: Date())
        self._typeSelected = State(initialValue: "Personal")
    }

    init(key: String, item: ToDoItem) {
        self._defaultTitleText = State(initialValue: item.getTitleText())
        self._titleText = State(initialValue: item.getTitleText())
        self._descriptionText = State(initialValue: item.getDecriptionText())
        self._selectedDate = State(initialValue: item.getDate())
        self._typeSelected = State(initialValue: item.getType())
        self.id = key
    }

    init(date: Date) {
        self._defaultTitleText = State(initialValue: "Write Something Here")
        self._titleText = State(initialValue: "")
        self._descriptionText = State(initialValue: "")
        self._selectedDate = State(initialValue: date)
        self._typeSelected = State(initialValue: "Personal")
    }
    
    
    

}

struct InformationView_Previews: PreviewProvider {
    static var previews: some View {
        InformationView()
    }
}
