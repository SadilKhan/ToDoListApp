import SwiftUI

struct DateField: View {
    @Binding var selectedDate: Date
    let StartingDate: Date = Date()
    var body: some View {
        // Date Picker
        DatePicker("Date",
            selection: $selectedDate,
            in: StartingDate...,
            displayedComponents: [.date])
            .padding(.horizontal, 10)
    }
}

