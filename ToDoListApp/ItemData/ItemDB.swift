import Foundation

class ItemDB: ObservableObject {

    @Published var allItems: [String: ToDoItem] = [:]
    @Published var allKeys: [String]=[]

    /// Adds a new ToDoItem in allItems
    /// - Parameter item: an object of the class ToDoItem
    func appendItem(_ item: ToDoItem) {
        let key=UUID().uuidString
        allItems[key] = item
        allKeys.append(key)
    }
    
//    init(){
//        allItems["1"]=ToDoItem(titleText: "1.Grocery", descriptionText: "Nothn", date: "2022-12-1")
//        allItems["2"]=ToDoItem(titleText: "2.Study", descriptionText: "I have to study this and that I have to study this and that I have to study this and that I have to study this and that I have to study this and that", date: "2022-12-1")
//        allItems["3"]=ToDoItem(titleText: "3.Cleaning", descriptionText: "Nothn", date: "2022-12-1")
//        allKeys.append("1")
//        allKeys.append("2")
//        allKeys.append("3")
//    }

    /// Deletes an item from allItems database
    /// - Parameter index: an IndexSet
    func deleteItem(index: IndexSet) {
        index.forEach { i in
            allItems.removeValue(forKey: allKeys[i])
            allKeys.remove(at: i)
        }
    }
}
