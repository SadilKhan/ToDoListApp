import SwiftUI

/// Main Page

// MARK: MAIN PAGE
struct ContentView: View {

    // MARK: PROPERTIES
    let navTitle: String = "Todos"
    @StateObject var itemDataBase: ItemDB = ItemDB()
    @State var toUpdate: Bool = false
    @State var searchText: String = ""

    // MARK: BODY
    var body: some View {
        NavigationView { // NAV START
            ZStack {
                Text("Add a new Item")
                    .font(.title2)
                    .fontWeight(.light)
                List { // LIST START
                    // Section start for Date
                    ForEach(sortDateKeys(searchResults), id: \.self) {
                        dateKey in
                        if let val = searchResults[dateKey]
                        {
                            let _ = print(Array(searchResults.keys).sorted())
                            let sortedValKeys = sortKeysByDone(val, itemDataBase.allDone)
                            // SECTION START FOR ITEMS BELONGING TO A DATE
                            Section {
                                ForEach(sortedValKeys, id: \.self) { key in
                                    NextPageNavLink(key: key)
                                }
                                    .onDelete(perform: { indexSet in itemDataBase.deleteItem(indexSet, dateKey, sortedValKeys) })

                            } header: {
                                HStack {
                                    Text(
                                        String(dateKey)
                                    )
                                        .textCase(nil)
                                        .font(.caption)
                                        .foregroundColor(Color.blue)
                                    // Add a plus button beside every date
                                    NavigationLink {
                                        InformationView(date: val[sortedValKeys[0]] != nil ? val[sortedValKeys[0]]!.getDate() : Date())
                                    } label: {
                                        Image(systemName: "plus.circle.fill")
                                            .foregroundColor(Color.orange)
                                    }


                                }
                            } footer: {
                                Text(val.count > 1 ? "\(val.count) items" : "\(val.count) item")
                                    .font(.caption)
                                    .foregroundColor(Color.secondary)
                            } // SECTION END
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
                        UndoButton()
                    }
                    // Add Undo for new items
                    ToolbarItem(placement: .navigationBarTrailing) {
                        HelpButton()
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


/// Undo function which adds the deleted items
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
        HStack {
            Toggle(isOn: $isDone) {
            }
                .toggleStyle(CheckToggleStyle())
                .onChange(of: isDone) { newValue in
                itemDataBase.allDone[key] = newValue
            }
            Text(itemDataBase.allItems[key] != nil ? itemDataBase.allItems[key]!.getTitleText() : "")
                .strikethrough(isDone)
                .font(.body)
            //.fontWeight(.medium)
            .foregroundColor(.primary)
            Spacer()
            HStack {
                Text(itemDataBase.allItems[key] != nil ? itemDataBase.allItems[key]!.getType() : "")
                    .font(.caption)
                    .fontWeight(.light)

                Circle()
                    .fill(itemDataBase.allItems[key] != nil ? colorForType(itemDataBase.allItems[key]!.getType()) : colorForType(""))
                    .frame(width: 10, height: 10)
            }
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
