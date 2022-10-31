import Foundation
import SwiftUI
/// The database management functionalities for all the ToDoItems
class ItemDB: ObservableObject {

    @Published var allItems: [String: ToDoItem] = [:]
    @Published var allDeletedItems:[(String,ToDoItem)] = []
    @Published var allKeys: [String] = []
    @Published var allColors: [String: Color] = [:]
    @Published var allDone: [String: Bool] = [:]

    /// Adds a new ToDoItem in allItems
    /// - Parameter item: an object of the class ToDoItem
    func appendItem(_ item: ToDoItem) {
        let key = UUID().uuidString
        allItems[key] = item
        allKeys.append(key)
        allColors[key] = randomColorChooser() // Adds a random color for every item
        allDone[key] = false
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
            addDeletedItem(i)
            allItems.removeValue(forKey: allKeys[i])
            allColors.removeValue(forKey: allKeys[i])
            allDone.removeValue(forKey: allKeys[i])
            allKeys.remove(at: i)
        }
    }

    func deleteItemDone() {
        for i in (0...(allKeys.count-1)).reversed() {
            if let val = allDone[allKeys[i]] {
                if val {
                    addDeletedItem(i)
                    allItems.removeValue(forKey: allKeys[i])
                    allColors.removeValue(forKey: allKeys[i])
                    allDone.removeValue(forKey: allKeys[i])
                    allKeys.remove(at: i) }
            }
        }
    }
    
    /// Keeps track of deleted item for undo function
    /// - Parameter idx: Int
    func addDeletedItem(_ idx:Int){
        if let item = allItems[allKeys[idx]]{
            allDeletedItems.insert((allKeys[idx], item),at:0)
        }
        if allDeletedItems.count>5{
            allDeletedItems=Array(allDeletedItems[...5])
        }
    }
}
