import Foundation


/// Class for storing the To-Do Item information
///
/// The ToDoItem class objects are the items listed on the Main Page. It stores and returns the metadata like title, description and date of an item.
///
class ToDoItem: Identifiable {
    
    // MARK: Properties
    private var titleText: String
    private var descriptionText:String
    private var date:String
    var isDone:Bool=false
    
    init(titleText: String, descriptionText: String, date: String) {
        self.titleText = titleText
        self.descriptionText = descriptionText
        self.date = date
    }
    // MARK: Methods
    func getTitleText() -> String{
        return titleText
    }
    
    func getDecriptionText() -> String{
        return descriptionText
    }
    func getDate() -> String{
        return date
    }
    
    
    func update(_ titleText: String?, _ descriptionText: String?, _ date: String?){
        if let _ = titleText {
            self.titleText=titleText!
        }
        
        if let _ = descriptionText {
            self.descriptionText = descriptionText!
        }
        
        if let _ = date {
            self.date = date!
        }
    }
}
