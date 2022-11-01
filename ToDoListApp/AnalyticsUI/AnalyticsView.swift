//
//  AnalyticsView.swift
//  ToDoListApp
//
//  Created by Md. Sadil Khan on 01/11/2022.
//

import SwiftUI

struct AnalyticsView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Text("Nothing to show")
                    .font(.title2)
                    .fontWeight(.light)
            }
                .navigationTitle("Analytics")
        }
    }
}

struct AnalyticsView_Previews: PreviewProvider {
    static var previews: some View {
        AnalyticsView()
    }
}
