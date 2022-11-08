
import SwiftUI
// MARK: NAVIGATION PAGE LINK
struct NextPageNavLink: View {
    var key: String
    @EnvironmentObject var itemDataBase: ItemDB
    @ObservedObject var viewRouter: ViewRouter
    var body: some View {
        NavigationLink {
            if let item = itemDataBase.allItems[key] {
                InformationView(key: key, item: item, viewRouter)
            }
        } label: {
            ItemList(key: key)
        }
    }
}

// MARK: NEW BUTTON
/// New Button which opens InformationView Window
struct NewButton: View {
    @ObservedObject var viewRouter: ViewRouter
    var body: some View {
        NavigationLink {
            InformationView(viewRouter)
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
    @ObservedObject var viewRouter: ViewRouter
    var body: some View {
        NavigationLink {
            withAnimation(.spring(response: 0.9, dampingFraction: 0.5)) {
                InformationView(viewRouter)
            }
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


/// Adds a back button on the information page
struct BackButton: View {
    @Binding var presentationMode: PresentationMode
    @ObservedObject var viewRouter: ViewRouter
    var body: some View {
        Button {
            viewRouter.showNavigator = true
            $presentationMode.wrappedValue.dismiss()
        } label: {
            HStack {
                Image(systemName: "chevron.backward.circle")
                Text("Back")
                    .fontWeight(.medium)
            }
        }

    }
}
