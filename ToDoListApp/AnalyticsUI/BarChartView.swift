//
//  BarChartView.swift
//  ToDoListApp
//
//  Created by Md. Sadil Khan on 01/11/2022.
//

import SwiftUI

struct BarChartView: View {
    @State var itemDataBase: ItemDB
    var body: some View {
        ZStack {
            if itemDataBase.allItems.count == 0 {
                Text("No Chart Available")
                    .foregroundColor(.primary)
                    .font(.title2)
                    .fontWeight(.light)
            }

            RoundedRectangle(cornerRadius: 30)
                .frame(width: 350, height: 400)
                .foregroundColor(.white.opacity(itemDataBase.allItems.count > 0 ? 0.6 : 0))
                .shadow(radius: 5, y: 10)
        }
    }

    init(_ itemDataBase: ItemDB) {
        self.itemDataBase = itemDataBase
    }
    init() {
        self.itemDataBase = ItemDB()
    }
}

struct BarChartView_Previews: PreviewProvider {
    static var previews: some View {
        BarChartView(ItemDB())
    }
}
