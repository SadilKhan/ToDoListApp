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
        dateText += " - Tommorrow"
    }

    return dateText

}


