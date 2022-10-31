import SwiftUI

/// Main Page
struct MenuView: View {
    let navTitle: String = "All Lists"
    @StateObject var itemDataBase: ItemDB = ItemDB()
    var body: some View {
        NavigationView { // NAV START
            List { // LIST START
                ForEach(itemDataBase.allItems.sorted(by: { $0.0 > $1.0 }), id: \.key) { key, value in
                    NavigationLink {
                        InformationView(key: key, item: value)
                    } label: {
                        ItemList(item: value)
                    }

                }
                    .onDelete(perform: itemDataBase.deleteItem)

            } // LIST END
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


/// The item lists that will be shown on the main page
/// - Parameters
///    - item: a ToDoItem object
struct ItemList: View {
    let item: ToDoItem
    var body: some View {

        HStack {
            Circle()
                .fill(randomColorChooser())
                .frame(width: 35, height: 35)
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
        .padding(.vertical,10)
//        .padding(10)
//        .background(ColorsDB().bgColorItemList.opacity(0.1).cornerRadius(20))
//            .padding(.horizontal,10)
    }

    init(item: ToDoItem) {
        self.item = item
    }
}



struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
