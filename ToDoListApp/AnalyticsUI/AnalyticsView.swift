//
//  AnalyticsView.swift
//  ToDoListApp
//
//  Created by Md. Sadil Khan on 01/11/2022.
//

import SwiftUI
import Charts

struct AnalyticsView: View {
    @EnvironmentObject var itemDataBase: ItemViewModel
    @Environment(\.colorScheme) var colorscheme
    @Binding var searchText: String
    @ObservedObject var viewRouter: ViewRouter
    @State var typeData: [String: Int] = [:]
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                boxView
                Spacer()
            }
                .onAppear {
                updateTypeDB()
            }
                .navigationTitle("Analytics")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

extension AnalyticsView {

    private var boxView: some View {
        VStack (alignment: .leading) {
            HStack {

                rectangularButton(title: "Personal")
                rectangularButton(title: "Work", paddingStyle: .trailing)
            }

            HStack {
                rectangularButton(title: "Sports")
                rectangularButton(title: "Meeting", paddingStyle: .trailing)
            }

            HStack {
                rectangularButton(title: "Shopping")
                rectangularButton(title: "Misc", paddingStyle: .trailing)

            }
            Spacer()
        }



    }
}

extension AnalyticsView {

    /// Method for calculating the number of items per tasktype
    func updateTypeDB() {
        for (_, value) in itemDataBase.allItems {
            if let arr = typeData[value.getType()] {
                withAnimation(.easeInOut(duration: 0.8)) {
                    typeData[value.getType()] = arr + 1
                }
            } else {
                withAnimation(.easeInOut(duration: 0.8)) {
                    typeData[value.getType()] = 1
                }
            }
        }
    }

    func rectangularButton(title: String, paddingStyle: Edge.Set = .leading) -> some View {
        Button {
            withAnimation(.spring()) {
                searchText = title
                self.viewRouter.changeActiveButton(.home)
            }
        } label: {
            addRectangle(title: title)
                .padding(paddingStyle, 10)
        }
    }


    /// Adds a box in Analytics page
    /// - Parameters:
    ///   - title: String. The task type
    ///   - textColor: Color object. Color of the text. Default is white
    /// - Returns: Returns a rounded rectangle with texts
    func addRectangle(title: String, textColor: Color = .white) -> some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                colorForType(title)
                    .font(.largeTitle)
                Text(title)
                    .font(.title)
                    .foregroundColor(colorscheme == .light ? .white : .black)
            }
            if let number = typeData[title] {
                Text(number == 1 ? "1 task" : "\(number) tasks")
                    .font(.caption)
                    .foregroundColor(colorscheme == .light ? .white : .black)
            } else {
                Text("0 tasks")
                    .font(.caption)
                    .foregroundColor(colorscheme == .light ? .white : .black)
            }

        }
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 175)
            .padding(.horizontal, 10)
            .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(colorscheme == .light ? ColorsDB.colorManager.boxColorLightMode : ColorsDB.colorManager.boxColorDarkMode)
        )

    }
}

