import SwiftUI

// MARK: MAIN VIEW
/// The main view where tasks are shown
struct TaskView: View {
    let navTitle: String
    @EnvironmentObject private var itemDataBase: ItemViewModel
    @State private var toUpdate: Bool = false
    @Binding var searchText: String
    @ObservedObject var viewRouter: ViewRouter
    let date = Date()

    var body: some View {
        NavigationView { // NAV START
            //
            listView
            // Navigation Bar Customization
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always)) {
                if searchText == "" {
                    Text("Looking for today's tasks").font(.body).searchCompletion("Today")
                    Text("Looking for tasks in the current month").font(.body).searchCompletion(date.month)
                    Text("Looking for personal tasks").font(.body).searchCompletion("Personal")
                    Text("Looking for completed tasks").font(.body).searchCompletion("Completed")

                }
            }
                .navigationTitle(navTitle)
                .toolbar { // TOOLBAR START
                // Edit Button
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                // Update Button
                ToolbarItem(placement: .navigationBarLeading) {
                    UpdateButton(toUpdate: $toUpdate)
                }
                // Add Undo for new items
                ToolbarItem(placement: .navigationBarTrailing) {
                    UndoButton()
                }
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    DarkModeButton()
//                }
                // Add Button for new items
                ToolbarItem(placement: .navigationBarTrailing) {
                    NewButton(viewRouter: viewRouter)
                }
            }
        } // NAV END


    }

}

// MARK: SUB VIEWS

extension TaskView {

    /// The results of the search textfield
    private var searchResults: [String: [String: ToDoItem]] {
        var selectedKeys: [String: [String: ToDoItem]] = [:]
        var temp: [String: ToDoItem] = [:]
        if searchText.isEmpty {
            return itemDataBase.dateMapped
        } else {
            for (dateKey, _) in itemDataBase.dateMapped {
                if let valueDict = itemDataBase.dateMapped[dateKey] {
                    temp = [:]
                    for (key, value) in valueDict {
                        if searchText.lowercased().contains("done") || searchText.lowercased().contains("complete") || searchText.lowercased().contains("finish") {

                            if let isDone = itemDataBase.allDone[key] {
                                if isDone { temp[key] = value }
                            }

                        } else if value.getTitleText().lowercased().contains(searchText.lowercased()) || value.getDecriptionText().lowercased().contains(searchText.lowercased()) || value.getType().lowercased().contains(searchText.lowercased()) || dateKey.lowercased().contains(searchText.lowercased()) {
                            temp[key] = value
                        }
                    }
                    if temp.count > 0 {
                        selectedKeys[dateKey] = temp
                    }
                }
            }
            temp = [:]
            return selectedKeys
        }
    }

    /// The Task list view
    private var listView: some View {
        List { // LIST START
            // Section start for Date
            ForEach(sortDateKeys(searchResults), id: \.self) {
                dateKey in
                if let val = searchResults[dateKey], let showSection = self.itemDataBase.showSection[dateKey]
                {
                    let sortedValKeys = sortKeysByDone(val, itemDataBase.allDone)
                    // SECTION START FOR ITEMS BELONGING TO A DATE
                    Section {
                        if showSection {
                            ForEach(sortedValKeys, id: \.self) { key in
                                NextPageNavLink(key: key, viewRouter: viewRouter)
                            }
                                .onDelete(perform: {
                                indexSet in
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    itemDataBase.deleteItem(indexSet, dateKey, sortedValKeys)
                                }
                            })
                        }
                    } header: {
                        HStack {
                            // The Date Text
                            Text(
                                String(dateKey)
                            )
                                .textCase(nil)
                                .font(.caption)
                                .foregroundColor(Color.blue)
                            // Add a plus button beside every date
                            NavigationLink {
                                InformationView(date: val[sortedValKeys[0]] != nil ? val[sortedValKeys[0]]!.getDate() : Date(), viewRouter)
                            } label: {
                                Image(systemName: "plus.circle.fill")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                    .foregroundColor(Color.orange)
                            }
                            Spacer()
                            // The Collapse Key
                            Button {
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    self.itemDataBase.toggleShowSection(dateKey)
                                }
                            } label: {
                                Image(systemName: "greaterthan.circle.fill")
                                    .renderingMode(.original)
                                    .resizable()
                                    .foregroundColor(.orange)
                                    .frame(width: 25, height: 25)
                                    .rotationEffect(Angle(degrees: itemDataBase.showSection[dateKey] ?? false ? 90 : 0))
                            }
                        }
                    } footer: {
                        Text(val.count > 1 ? "\(val.count) items" : "\(val.count) item")
                            .font(.caption)
                            .foregroundColor(Color.secondary)
                    } // SECTION END
                    .listRowSeparator(.hidden)
                }
            }
                .onChange(of: toUpdate) { _ in
                withAnimation(.easeInOut(duration: 0.5)) {
                    itemDataBase.deleteItemDone()
                }
            }
        }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
    }
}

// MARK: ITEM LIST

/// The item lists that will be shown on the main page
///
/// The view takes a key as a parameter
/// - Parameters
///    - key: String
struct ItemList: View {
    var key: String
    @EnvironmentObject var itemDataBase: ItemViewModel
    @State var isDone: Bool = false
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    var body: some View {
        ZStack {
            if colorScheme == .light {
                RoundedRectangle(cornerRadius: 10)
                    .fill(ColorsDB().listItemColor)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, -10)
                    .padding(.trailing, -15)
                    .padding(.vertical, -4)
                    .shadow(radius: 3, y: 2)
                    .opacity(0.5)
            }
            HStack {
                Button {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        isDone.toggle()
                        itemDataBase.allDone[key] = isDone
                    }
                } label: {
                    Image(systemName: isDone ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(isDone ? .purple : Color(uiColor: UIColor.magenta))
                        .accessibilityLabel(Text(isDone ? "Checked" : "Unchecked"))
                        .imageScale(.large)
                }
                    .buttonStyle(.plain)
                    .onAppear {
                    isDone = itemDataBase.allDone[key] ?? false
                }
                // Title
                Text(itemDataBase.allItems[key] != nil ? itemDataBase.allItems[key]!.getTitleText() : "")
                    .strikethrough(itemDataBase.allDone[key] ?? false)
                    .font(.body)
                //.fontWeight(.medium)
                .foregroundColor(.primary)
                Spacer()
                HStack {
                    // Type
                    Text(itemDataBase.allItems[key] != nil ? itemDataBase.allItems[key]!.getType() : "")
                        .font(.caption)
                        .fontWeight(.light)
                    if itemDataBase.allItems[key] != nil {
                        colorForType(itemDataBase.allItems[key]!.getType())
                    }
                }
            }
        }

            .contextMenu {
            // Duplicate Button
            Button(action: {
                if let item = itemDataBase.allItems[key] {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        self.itemDataBase.appendItem(item)
                    }
                }
            }, label: {
                    Text("Duplicate Task")
                })
        }
            .padding(.vertical, self.colorScheme == .light ? 10 : 0)
    }

    init(key: String) {
        self.key = key
    }

}
