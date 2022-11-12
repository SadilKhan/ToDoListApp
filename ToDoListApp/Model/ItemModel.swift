import Foundation
import SwiftUI

/// Class for storing the To-Do Item information
///
/// The ToDoItem class objects are the items listed on the Main Page. It stores and returns the metadata like title, description and date of an item.
///
class ToDoItem: Identifiable, Codable {

    // MARK: Properties
    var id = UUID().uuidString
    private var titleText: String
    private var descriptionText: String
    private var date: Date
    var isDone: Bool = false
    private var type: String


    init(titleText: String, descriptionText: String, type: String, date: Date) {
        self.titleText = titleText
        self.descriptionText = descriptionText
        self.type = type
        self.date = date
    }

    // MARK: Methods
    func getTitleText() -> String {
        return titleText
    }

    func getDecriptionText() -> String {
        return descriptionText
    }
    func getDate() -> Date {
        return date
    }
    func getType() -> String {
        return type
    }
}

extension ToDoItem: Equatable {
    static func == (class1: ToDoItem, class2: ToDoItem) -> Bool {
        return
        class1.id == class2.id
    }
}


enum TaskType: String {
    case Personal
    case Work
    case Meeting
    case Sports
    case Shopping
    case Misc
}
