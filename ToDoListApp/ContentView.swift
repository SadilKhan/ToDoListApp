import SwiftUI

/// Main Page
struct ContentView: View {
    let navTitle: String = "All Lists"
    @StateObject var itemDataBase: ItemDB = ItemDB()
    var body: some View {
        NavigationView { // NAV START
            List { // LIST START
                ForEach(itemDataBase.allKeys, id: \.self) { key in
                    NavigationLink {
                        InformationView(key: key, item: itemDataBase.allItems[key]!)
                    } label: {
                        ItemList(item: itemDataBase.allItems[key]!)
                    }
                }
                    .onDelete(perform: itemDataBase.deleteItem)
            } // LIST END
            .listStyle(.grouped)
            // Navigation Bar Customization
            .navigationTitle(navTitle)
                .toolbar {
                // Edit Button
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NewButton()
                }
            }
        } // NAV END
        .environmentObject(itemDataBase)
    }
}


/// New Button which opens InformationView Window
struct NewButton: View {
    var body: some View {
        NavigationLink {
            InformationView()
        } label: {
            Text("New")
        }

    }
}

struct AddButton: View {
    var body: some View {
        NavigationLink {
            InformationView()
        } label: {
            Image(systemName: "plus")
        }
    }
}

/// The item lists that will be shown on the main page
/// - Parameters
///    - item: a ToDoItem object
struct ItemList: View {
    var item: ToDoItem
    var bgColor=randomColorChooser()
    @State var isDone: Bool
    var body: some View {
        HStack {
            Circle()
                .fill(bgColor)
                .frame(width: 35, height: 35)
            Toggle(isOn: $isDone) {
                VStack(alignment: .leading) {
                    Text(self.item.getTitleText())
                        .font(.body)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    Text(self.item.getDecriptionText())
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .frame(maxHeight: 10, alignment: .leading)
                }
            }
        }
//            .padding(.vertical, 10)
//        .padding(10)
//        .background(ColorsDB().bgColorItemList.opacity(0.1).cornerRadius(20))
//            .padding(.horizontal,10)
    }

    init(item: ToDoItem) {
        self.item = item
        self.isDone = item.isDone
    }

}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
