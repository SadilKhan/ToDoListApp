//
//  HomeView.swift
//  ToDoListApp
//
//  Created by Md. Sadil Khan on 01/11/2022.
//

import SwiftUI

struct HomeView: View {
    let navTitle: String = "Todos"
    @EnvironmentObject var itemDataBase: ItemDB
    @State var toUpdate: Bool = false
    @State var searchText: String = ""
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
    }

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
                        if value.getTitleText().lowercased().contains(searchText.lowercased()) || value.getDecriptionText().lowercased().contains(searchText.lowercased()) || value.getType().lowercased().contains(searchText.lowercased()) || dateKey.lowercased().contains(searchText.lowercased()) {
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
