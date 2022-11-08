//
//  AnalyticsView.swift
//  ToDoListApp
//
//  Created by Md. Sadil Khan on 01/11/2022.
//

import SwiftUI

struct AnalyticsView: View {
    @State var itemDataBase: ItemDB
    var body: some View {
        NavigationView {
            ScrollView {
                ZStack {
                    BarChartView(itemDataBase)
                }
                    .navigationTitle("Analytics")
            }
        }

    }
    init(_ itemDataBase: ItemDB) {
        self.itemDataBase = itemDataBase
    }
    init() {
        self.itemDataBase = ItemDB()
    }
}

struct AnalyticsView_Previews: PreviewProvider {
    static var previews: some View {
        AnalyticsView()
    }
}
