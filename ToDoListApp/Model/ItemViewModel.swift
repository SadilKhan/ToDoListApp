import Foundation
import SwiftUI

// MARK: ALL PROPERTIES
/// The database manager
class ItemViewModel: ObservableObject {

    let FILEPATH: String = "data.dat"

    // MARK: PROPERTIES TO SAVE
    @Published var allItems: [String: ToDoItem] = [:]
    @Published var allDone: [String: Bool] = [:]
    @Published var showSection: [String: Bool] = [:]

    // MARK: DERIVED PROPERTIES
    @Published var allDeletedItems: [(String, ToDoItem)] = []
    @Published var allKeys: [String] = []
    @Published var dateMapped: [String: [String: ToDoItem]] = [:]


    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en-US")
        formatter.setLocalizedDateFormatFromTemplate("YYYYMMMMd")
        return formatter
    }

//
//    init() {
//
//    }
}

// MARK: ALL METHODS RELATED TO LOADING AND SAVING DATA
extension ItemViewModel {


    private static func getPath(fileName: String) throws -> URL {
        try FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false)
            .appendingPathComponent(fileName)
    }

    private static func fileURL() throws -> [URL] {
        var URLS: [URL] = []
        try URLS.append(getPath(fileName: "item.data"))
        try URLS.append(getPath(fileName: "isDone.data"))
        try URLS.append(getPath(fileName: "showSection.data"))

        return URLS

    }

    static func loadData(completion: @escaping (Result<[String:ToDoItem], Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let fileURL = try fileURL()[0]
                guard let file = try? FileHandle(forReadingFrom: fileURL) else {
                    DispatchQueue.main.async {
                        completion(.success([:]))
                    }
                    return
                }

                let decodedData = try JSONDecoder().decode([String: ToDoItem].self, from: file.availableData)
                DispatchQueue.main.async {
                    completion(.success(decodedData))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }

            }
        }
    }
    static func loadAllDone(completion: @escaping (Result<[String:Bool], Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let fileURL = try fileURL()[1]
                guard let file = try? FileHandle(forReadingFrom: fileURL) else {
                    DispatchQueue.main.async {
                        completion(.success([:]))
                    }
                    return
                }

                let decodedData = try JSONDecoder().decode([String: Bool].self, from: file.availableData)
                DispatchQueue.main.async {
                    completion(.success(decodedData))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }

            }
        }
    }
    static func loadShowSection(completion: @escaping (Result<[String:Bool], Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let fileURL = try fileURL()[2]
                guard let file = try? FileHandle(forReadingFrom: fileURL) else {
                    DispatchQueue.main.async {
                        completion(.success([:]))
                    }
                    return
                }

                let decodedData = try JSONDecoder().decode([String: Bool].self, from: file.availableData)
                DispatchQueue.main.async {
                    completion(.success(decodedData))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }

            }
        }
    }

    static func saveData(allItems: [String: ToDoItem], completion: @escaping (Result<Int, Error>) -> Void) {
        do {
            let data = try JSONEncoder().encode(allItems)
            let outFile = try fileURL()[0]
            try data.write(to: outFile)
            DispatchQueue.main.async {
                completion(.success(allItems.count))
            }
        } catch {
            DispatchQueue.main.async {
                completion(.failure(error))
            }
        }
    }

    static func saveAllDone(allDone: [String: Bool], completion: @escaping (Result<Int, Error>) -> Void) {
        do {
            let data = try JSONEncoder().encode(allDone)
            let outFile = try fileURL()[1]
            try data.write(to: outFile)
            DispatchQueue.main.async {
                completion(.success(allDone.count))
            }
        } catch {
            DispatchQueue.main.async {
                completion(.failure(error))
            }
        }
    }
    static func saveShowSection(showSection: [String: Bool], completion: @escaping (Result<Int, Error>) -> Void) {
        do {
            let data = try JSONEncoder().encode(showSection)
            let outFile = try fileURL()[2]
            try data.write(to: outFile)
            DispatchQueue.main.async {
                completion(.success(showSection.count))
            }
        } catch {
            DispatchQueue.main.async {
                completion(.failure(error))
            }
        }
    }
}

// MARK: ALL METHODS RELATED TO UPDATE
extension ItemViewModel {
    /// Adds a new ToDoItem in allItems
    /// - Parameter item: an object of the class ToDoItem
    func appendItem(_ item: ToDoItem) {
        let key = UUID().uuidString
        allItems[key] = item
        allKeys.append(key)
        //allColors[key] = randomColorChooser() // Adds a random color for every item
        allDone[key] = false

        updateDateMap(item, key)
    }

    ///  Updates the datemap dictionary
    /// - Parameters:
    ///   - item: A ToDoItem Object
    ///   - key: String
    ///   - updateShowSection: Boolean variable. It asks whether showsection is to be updated
    func updateDateMap(_ item: ToDoItem, _ key: String, _ updateShowSection: Bool = true) {
        // Update date mapped dictionary
        let dateKey = dateToString(item.getDate())
        if var arr = dateMapped[dateKey] {
            arr[key] = item
            dateMapped[dateKey] = arr
        } else {
            dateMapped[dateKey] = [key: item]
            if updateShowSection {
                showSection[dateKey] = true
            }
        }
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
}

// MARK: ALL METHODS RELATED TO DELETION
extension ItemViewModel {
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
            //allColors.removeValue(forKey: allKeys[j])
            allDone.removeValue(forKey: allKeys[j])
            allKeys.remove(at: j)
        }
    }


    /// Deletes the items that has toggle on
    func deleteItemDone() {
        for i in (0..<allKeys.count).reversed() {
            if let val = allDone[allKeys[i]] {
                if val {
                    addDeletedItem(i)
                    if let item = allItems[allKeys[i]] {
                        deleteDateMap(dateToString(item.getDate()), allKeys[i])
                    }
                    allItems.removeValue(forKey: allKeys[i])
                    //allColors.removeValue(forKey: allKeys[i])
                    allDone.removeValue(forKey: allKeys[i])
                    allKeys.remove(at: i) }
            }
        }
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

    func reset() {
        allItems = [:]
        allDone = [:]
        allKeys = []
        allDeletedItems = []
        dateMapped = [:]
    }

}

// MARK: ALL METHODS FOR UTILITIES
extension ItemViewModel {
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


    /// Method which toggles showing the section on the main page
    ///
    /// The showSection dictionary determines which section to show on the main page. This method manipulates the dictionary. It takes a date key string and toggle its visibility.
    ///
    /// - Parameter dateKey: The date string
    func toggleShowSection(_ dateKey: String) {
        if let willShowSection = self.showSection[dateKey] {
            if willShowSection {
                self.showSection[dateKey] = false
            } else {
                self.showSection[dateKey] = true
            }
        }
    }
}
