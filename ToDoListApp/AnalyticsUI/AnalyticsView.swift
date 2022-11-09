//
//  AnalyticsView.swift
//  ToDoListApp
//
//  Created by Md. Sadil Khan on 01/11/2022.
//

import SwiftUI
import Charts

struct AnalyticsView: View {
    @EnvironmentObject var itemDataBase: ItemDB
    @State var typeData: [String: Int] = [:]
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                if itemDataBase.allItems.count == 0 {
                    Text("No Chart Available")
                        .foregroundColor(.primary)
                        .font(.title2)
                        .fontWeight(.light)
                } else {
                    barChartView
                }
                Spacer()
            }
                .navigationTitle("Analytics")
        }
    }
}

extension AnalyticsView {

    var barChartView: some View {
        VStack {
            Chart {
                ForEach(typeData.sorted(by: >), id: \.key) {
                    key, value in
                    BarMark(x: .value("Task Type", key), y: .value("Task Number", value), width: 50)
                        .foregroundStyle(Color.blue.gradient)
                }
            }
                .frame(height: 250)
                .padding(.horizontal, 20)
                .onAppear {
                updateTypeDB()
            }
        }
    }
}

extension AnalyticsView {

    func updateTypeDB() {
        for (_, value) in itemDataBase.allItems {
            if let arr = typeData[value.getType().rawValue] {
                withAnimation(.easeInOut(duration: 0.8)) {
                    typeData[value.getType().rawValue] = arr + 1
                }
            } else {
                withAnimation(.easeInOut(duration: 0.8)) {
                    typeData[value.getType().rawValue] = 1
                }
            }
        }
    }
}

struct AnalyticsView_Previews: PreviewProvider {
    static var previews: some View {
        AnalyticsView()
    }
}
