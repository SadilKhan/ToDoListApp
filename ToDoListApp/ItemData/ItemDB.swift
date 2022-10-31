import Foundation

class ItemDB {

    @Published var allItems: [String: ToDoItem] = [:]
    @Published var allKeys: [String]=[]

    /// Adds a new ToDoItem in allItems
    /// - Parameter item: an object of the class ToDoItem
    func appendItem(_ item: ToDoItem) {
        let key=UUID().uuidString
        allItems[key] = item
        allKeys.append(key)
    }

    /// Deletes an item from allItems database
    /// - Parameter index: an IndexSet
    func deleteItem(index: IndexSet) {
        index.forEach { i in
            allItems.removeValue(forKey: allKeys[i])
        }
    }
}
