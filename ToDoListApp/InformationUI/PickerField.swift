//
//  PickerField.swift
//  ToDoListApp
//
//  Created by Md. Sadil Khan on 01/11/2022.
//

import SwiftUI



struct PickerField: View {
    @State var priorityOptions: [TaskType] = [TaskType.Personal,TaskType.Work,TaskType.Misc]
    @Binding var selection: TaskType
    var body: some View {
        HStack {
            Text("Type")
//                .padding(10)
//                .padding(.horizontal,10)
//                .background {
//                    RoundedRectangle(cornerRadius: 20)
//                        .opacity(0.1)
//                }
            Spacer()
            
            Picker(selection: $selection) {
                ForEach(0..<priorityOptions.count, id: \.self) { i in
                    Text((priorityOptions[i].rawValue)).tag(priorityOptions[i])
                }
            } label: {
                Text("Priority")
            }
        }
        .padding(.horizontal,10)
    }
}
