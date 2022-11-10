import SwiftUI



struct PickerField: View {
    @State var priorityOptions: [TaskType] = [TaskType.Personal, TaskType.Work, TaskType.Misc]
    @Binding var selection: TaskType
    var body: some View {
        HStack {
            Text("Type")
            Spacer()
            Picker(selection: $selection) {
                ForEach(0..<priorityOptions.count, id: \.self) { i in
                    Text((priorityOptions[i].rawValue)).tag(priorityOptions[i])
                }
            } label: {
                Text("Priority")
            }
        }
            .padding(.horizontal, 10)
    }
}
