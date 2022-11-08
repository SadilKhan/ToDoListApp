import SwiftUI

/// Changes a date object to String using a dateformatter
///
/// This function also adds today and tomorrow string with the date
///
/// - Parameter date: A date object
/// - Returns: Returns a string object of the date
func dateToString(_ date: Date) -> String {

    var dateText: String

    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en-US")
        formatter.setLocalizedDateFormatFromTemplate("YYYYMMMMd")
        return formatter
    }

    dateText = dateFormatter.string(from: date)

    if dateText == dateFormatter.string(from: Date.now) {
        dateText += " - Today"
    } else if dateText == dateFormatter.string(from: Date.now.addingTimeInterval(86400)) {
        dateText += " - Tomorrow"
    }

    return dateText

}

/// Returns the integer value of a boolean variable (0 or 1)
/// - Parameter boolValue: Boolean Value
/// - Returns: Returns an integer
func boolToInt(_ boolValue: Bool) -> Int {
    boolValue ? 1 : 0
}


func sortMethod(_ key1: String, _ title1: String, _ key2: String, _ title2: String, _ allDone: [String: Bool]) -> Bool {

    if boolToInt(allDone[key1] ?? false) < boolToInt(allDone[key2] ?? true) {
        return true
    } else if boolToInt(allDone[key1] ?? false) == boolToInt(allDone[key2] ?? true) {
        if title1 < title2 {
            return true
        } else {
            return false
        }
    } else {
        return false
    }
}

/// Sort the keys according to the toggled parameter(isDone)
/// - Parameter itemDict: The dictionary of items of a specific date
/// - Returns: Returns the sorted key
func sortKeysByDone(_ itemDict: [String: ToDoItem], _ allDone: [String: Bool]) -> [String] {

    var sortedKeys: [String] = []
    //let sortedArr = itemDict.sorted(by: { s1, s2 in boolToInt(allDone[s1.key] ?? false) < boolToInt(allDone[s2.key] ?? true)})
    let sortedArr = itemDict.sorted(by: { s1, s2 in sortMethod(s1.key, s1.value.getTitleText(), s2.key, s2.value.getTitleText(), allDone) })

    sortedArr.forEach { (key: String, value: ToDoItem) in
        sortedKeys.append(key)
    }
    return sortedKeys

}

/// Gets an alert with a specified title
///
///This functions creates and returns an alert when save button is clicked with an empty title
///  ```
///  getAlert() -> Alert(title: Text("Empty Title Field"),
///                   message: Text("Enter something in Title"),
///                   dismissButton: .cancel())
///  ```
/// - Warning: There is no additional message in this alert
/// - Returns: Returns an alert with a title
func getAlert() -> Alert {

    return Alert(title: Text("Empty Title Field"),
        message: Text("Enter something in Title"),
        dismissButton: .cancel())
}


/// Sorting method according to the date
/// - Parameters:
///   - value1: First dictionary item of [String:ToDoItem]
///   - value2: Second dictionary item of [String:ToDoItem]
/// - Returns: Returns a bool value comparing value1 and value2
func dateSortMethod(_ value1:[String:ToDoItem],_ value2:[String:ToDoItem]) -> Bool{
    
    if value1.count>0 && value2.count>0{
        if Array(value1.values)[0].getDate() < Array(value2.values)[0].getDate(){
            return true
        } else {
            return false
        }
    }
    return false
}

/// Sort the dictionary by date
/// - Parameter dateDict: A [String:[String:ToDoItem]] dictionary
/// - Returns: Returns the keys of the sorted dictionary
func sortDateKeys(_ dateDict:[String:[String:ToDoItem]]) -> [String]{
    
    var sortedKeys:[String]=[]
    let sortedArr = dateDict.sorted(by: {s1,s2 in dateSortMethod(s1.value,s2.value)})
    
    sortedArr.forEach { (key: String, value: [String:ToDoItem]) in
        sortedKeys.append(key)
    }
    return sortedKeys
}

