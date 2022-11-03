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
    @State var isAnimated: Bool = false
    @ObservedObject var viewRouter: ViewRouter
    var id: String = ""
    @EnvironmentObject var itemDataBase: ItemDB
    @Environment(\.dismiss) private var dismiss
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    // MARK: BODY
    var body: some View {
        VStack {
            Spacer()
            // Title Text
            TitleTextField(defaultTitleText: $defaultTitleText, titleText: $titleText)
            // Description Field
            DescriptionField(descriptionText: $descriptionText)
            //Type Field
            Divider()
            PickerField(selection: $typeSelected)
            // Date Field
            Divider()
            DateField(selectedDate: $selectedDate)

            // Save Button
            Button {
                if self.titleText.count > 0 {
                    if itemDataBase.allItems[self.id] != nil {
                        let _ = print(descriptionText)
                        itemDataBase.updateItem(self.id, item: ToDoItem(titleText: self.titleText, descriptionText: self.descriptionText, type: self.typeSelected, date: self.selectedDate))
                    } else {
                        itemDataBase.appendItem(ToDoItem(titleText: titleText,
                            descriptionText: descriptionText, type: typeSelected,
                            date: selectedDate))
                    }
                    showAlert = false
                    viewRouter.showNavigator = true
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
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden()
                .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    BackButton(presentationMode: presentationMode, viewRouter: viewRouter)
                }
            }

        }
            .onAppear {
            self.viewRouter.showNavigator = false
        }

    }


    // MARK: CONSTRUCTOR

    init(_ viewRouter: ViewRouter) {
        self._defaultTitleText = State(initialValue: "Write Something Here ✍🏼")
        self._titleText = State(initialValue: "")
        self._descriptionText = State(initialValue: "")
        self._selectedDate = State(initialValue: Date())
        self._typeSelected = State(initialValue: "Personal")
        self.viewRouter = viewRouter
    }

    init(key: String, item: ToDoItem, _ viewRouter: ViewRouter) {
        self._defaultTitleText = State(initialValue: item.getTitleText())
        self._titleText = State(initialValue: item.getTitleText())
        self._descriptionText = State(initialValue: item.getDecriptionText())
        self._selectedDate = State(initialValue: item.getDate())
        self._typeSelected = State(initialValue: item.getType())
        self.id = key
        self.viewRouter = viewRouter
    }

    init(date: Date, _ viewRouter: ViewRouter) {
        self._defaultTitleText = State(initialValue: "Write Something Here")
        self._titleText = State(initialValue: "")
        self._descriptionText = State(initialValue: "")
        self._selectedDate = State(initialValue: date)
        self._typeSelected = State(initialValue: "Personal")
        self.viewRouter = viewRouter
    }




}

struct InformationView_Previews: PreviewProvider {
    static var previews: some View {
        InformationView(ViewRouter())
    }
}
