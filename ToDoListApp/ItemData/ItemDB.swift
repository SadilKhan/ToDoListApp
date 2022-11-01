import Foundation
import SwiftUI
/// The database management functionalities for all the ToDoItems
class ItemDB: ObservableObject {

    @Published var allItems: [String: ToDoItem] = [:]
    @Published var allDeletedItems: [(String, ToDoItem)] = []
    @Published var allKeys: [String] = []
    @Published var allColors: [String: Color] = [:]
    @Published var allDone: [String: Bool] = [:]
    @Published var dateMapped: [String: [String: ToDoItem]] = [:]
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en-US")
        formatter.setLocalizedDateFormatFromTemplate("YYYYMMMMd")
        return formatter
    }

    /// Adds a new ToDoItem in allItems
    /// - Parameter item: an object of the class ToDoItem
    func appendItem(_ item: ToDoItem) {
        let key = UUID().uuidString
        allItems[key] = item
        allKeys.append(key)
        allColors[key] = randomColorChooser() // Adds a random color for every item
        allDone[key] = false

        updateDateMap(item, key)

        //sortDateMap()
    }

    ///  Updates the datemap dictionary
    /// - Parameters:
    ///   - item: A ToDoItem Object
    ///   - key: String
    func updateDateMap(_ item: ToDoItem, _ key: String) {
        // Update date mapped dictionary
        let dateKey = dateToString(item.getDate())
        if var arr = dateMapped[dateKey] {
            arr[key] = item
            dateMapped[dateKey] = arr
        } else {
            dateMapped[dateKey] = [key: item]
        }
        //print("The keys are \(dateMapped.keys)")
    }


    /// Updates the parameter once an item is edited
    /// - Parameters:
    ///   - key: A string
    ///   - item: A ToDoItem object
    func updateItem(_ key: String, item: ToDoItem) {
        // Delete the old Value
        if let val = allItems[key] {
            deleteDateMap(dateToString(val.getDate()), key)
        }
        // Update the allItems Value
        allItems[key] = item
        // Update the allItems value
        updateDateMap(item, key)
        //sortDateMap()
    }

    /// Deletes an item from database and updates accordingly
    /// - Parameter index: an IndexSet
    /// - Parameter key: The Date key string
    func deleteItem(_ index: IndexSet, _ dateKey: String, _ sortedValKeys: [String]) {

        index.forEach { i in
            var j: Int = 0
            j = findKeyIndex(sortedValKeys[i])
            addDeletedItem(j)
            deleteDateMap(dateKey, allKeys[j])
            allItems.removeValue(forKey: allKeys[j])
            allColors.removeValue(forKey: allKeys[j])
            allDone.removeValue(forKey: allKeys[j])
            allKeys.remove(at: j)
        }
        //sortDateMap()
    }

    /// Find the index given the key
    /// - Parameter key: String
    /// - Returns: Returns an Integer
    func findKeyIndex(_ key: String) -> Int {
        for i in 0..<allKeys.count {
            if key == allKeys[i] {
                return i
            }
        }
        return 0
    }

    /// Deletes the items that has toggle on
    func deleteItemDone() {
        for i in (0...(allKeys.count - 1)).reversed() {
            if let val = allDone[allKeys[i]] {
                if val {
                    addDeletedItem(i)
                    if let item = allItems[allKeys[i]] {
                        deleteDateMap(dateToString(item.getDate()), allKeys[i])
                    }
                    allItems.removeValue(forKey: allKeys[i])
                    allColors.removeValue(forKey: allKeys[i])
                    allDone.removeValue(forKey: allKeys[i])
                    allKeys.remove(at: i) }
            }
        }
        //sortDateMap()
    }

    /// Deletes the item from Date Mapped dictionary
    /// - Parameters:
    ///   - dateKey: A String object of date
    ///   - key: String
    func deleteDateMap(_ dateKey: String, _ key: String) {
        if var dateValue = dateMapped[dateKey] {
            dateValue.removeValue(forKey: key)
            if dateValue.count > 0 {
                dateMapped[dateKey] = dateValue
            } else {
                dateMapped.removeValue(forKey: dateKey)
            }
        }
    }

    /// Keeps track of deleted item for undo function
    /// - Parameter idx: Int
    func addDeletedItem(_ idx: Int) {
        if let item = allItems[allKeys[idx]] {
            allDeletedItems.insert((allKeys[idx], item), at: 0)
        }
        if allDeletedItems.count > 5 {
            allDeletedItems = Array(allDeletedItems[...5])
        }
    }
}
