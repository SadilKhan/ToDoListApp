import SwiftUI

/// Main Page

// MARK: MAIN PAGE
struct ContentView: View {
    let navTitle: String = "Todos"
    @StateObject var itemDataBase: ItemDB = ItemDB()
    @State var toUpdate: Bool = false
    @State var searchText: String = ""
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        //formatter.dateFormat = "dd/MM/YY"
        //formatter.dateStyle = .long
        formatter.locale=Locale(identifier: "en-US")
        formatter.setLocalizedDateFormatFromTemplate("YYYYMMMMd")
        return formatter
    }
    //@State var isUndoDisabled:Bool
    var body: some View {
        NavigationView { // NAV START
            ZStack {
                Text("Add a new Item")
                    .font(.title2)
                    .fontWeight(.light)
                List { // LIST START
                    // Section start for Date
                    ForEach(Array(searchResults.keys), id: \.self) {
                        key in
                        if let val = searchResults[key]
                        {
                            // Section Start for Items under the date
                            Section {
                                ForEach(Array(val.keys), id: \.self) { key in
                                    NextPageNavLink(key: key)
                                }
                                    .onDelete(perform: { indexSet in itemDataBase.deleteItem(indexSet, key) })

                            } header: {
                                Text(key)
                                    .font(.caption)
                                    .foregroundColor(.blue)
                            } footer: {
                                Text(val.count > 1 ? "\(val.count) items" : "\(val.count) item")
                                    .font(.caption)
                                    .foregroundColor(Color.secondary)
                            }
                        }
                    }
                        .onChange(of: toUpdate) { _ in
                        itemDataBase.deleteItemDone()
                    }
                } // LIST END
                .listStyle(SidebarListStyle())
                // Navigation Bar Customization
                .searchable(text: $searchText)
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
                        HelpButton()
                    }
                    // Add Undo for new items
                    ToolbarItem(placement: .navigationBarTrailing) {
                        UndoButton()
                    }
                    // Add Button for new items
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NewButton()
                    }
                } // TOOLBAR END
            }
        } // NAV END
        .environmentObject(itemDataBase)
    }
//    init(){
//        self._isUndoDisabled = State(initialValue: true)
//    }

    var searchResults: [String: [String: ToDoItem]] {
        var selectedKeys: [String: [String: ToDoItem]] = [:]
        var temp: [String: ToDoItem] = [:]
        if searchText.isEmpty {
            return itemDataBase.dateMapped
        } else {
            for (dateKey, _) in itemDataBase.dateMapped {
                if let valueDict = itemDataBase.dateMapped[dateKey] {
                    temp = [:]
                    for (key, value) in valueDict {
                        if value.getTitleText().lowercased().contains(searchText.lowercased()) || value.getDecriptionText().lowercased().contains(searchText.lowercased()) {
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
}

// MARK: NAVIGATION PAGE LINK
struct NextPageNavLink: View {
    var key: String
    @EnvironmentObject var itemDataBase: ItemDB
    var body: some View {
        NavigationLink {
            if let item = itemDataBase.allItems[key] {
                InformationView(key: key, item: item)
            }
        } label: {
            ItemList(key: key)
        }
    }
}

// MARK: NEW BUTTON
/// New Button which opens InformationView Window
struct NewButton: View {
    var body: some View {
        NavigationLink {
            InformationView()
        } label: {
            Image(systemName: "plus")
        }

    }
}

// MARK: NEW BUTTON
/// New Button which opens InformationView Window
struct HelpButton: View {
    var body: some View {
        Link("Help", destination: URL(string: "https://github.com/SadilKhan/ToDoListApp")!)
    }
}

// MARK: ADD BUTTON
/// Opens a new window for adding an item
struct AddButton: View {
    var body: some View {
        NavigationLink {
            InformationView()
        } label: {
            Image(systemName: "plus")
        }
    }
}

struct UndoButton: View {
//    @Binding var isUndoDisabled: Bool
    @EnvironmentObject var itemDataBase: ItemDB
    var body: some View {
        Button {
            if itemDataBase.allDeletedItems.count > 0 {
                itemDataBase.appendItem(itemDataBase.allDeletedItems[0].1)
                itemDataBase.allDeletedItems.removeFirst()
            }
        } label: {
            Text("Undo")
        }
    }
}

// MARK: UPDATE BUTTON
/// Updates the current list based on the completed item
struct UpdateButton: View {
    @EnvironmentObject var itemDataBase: ItemDB
    @Binding var toUpdate: Bool
    var body: some View {
        Button {
            toUpdate.toggle()
        } label: {
            Text("Update")
        }

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
    @EnvironmentObject var itemDataBase: ItemDB
    @State var isDone: Bool = false
    var body: some View {
        Toggle(isOn: $isDone) {
            Text(itemDataBase.allItems[key] != nil ? itemDataBase.allItems[key]!.getTitleText() : "")
                .font(.body)
                .fontWeight(.medium)
                .foregroundColor(.primary)
//                Text(itemDataBase.allItems[key] != nil ? itemDataBase.allItems[key]!.getDecriptionText() : "")
//                    .font(.caption)
//                    .foregroundColor(.secondary)
        }
            .toggleStyle(CheckToggleStyle())
            .onChange(of: isDone) { newValue in
            itemDataBase.allDone[key] = newValue
        }
    }

    init(key: String) {
        self.key = key
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
