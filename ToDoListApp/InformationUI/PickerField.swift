import SwiftUI



struct PickerField: View {
    @State var priorityOptions: [String] = [TaskType.Personal.rawValue,
        TaskType.Work.rawValue,
        TaskType.Sports.rawValue,
        TaskType.Meeting.rawValue,
        TaskType.Shopping.rawValue,
        TaskType.Misc.rawValue]
    @Binding var selection: String
    var body: some View {
        HStack {
            Text("Type")
            Spacer()
            Picker(selection: $selection) {
                ForEach(0..<priorityOptions.count, id: \.self) { i in
                    Text((priorityOptions[i])).tag(priorityOptions[i])
                }
            } label: {
                Text("Priority")
            }
        }
            .padding(.horizontal, 10)
    }
}
