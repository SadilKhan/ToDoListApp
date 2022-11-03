//
//  NoItemsView.swift
//  ToDoListApp
//
//  Created by Md. Sadil Khan on 02/11/2022.
//

import SwiftUI

struct NoItemsView: View {
    @State var navTitle: String
    var body: some View {
        NavigationView {
            VStack {
                //Divider()
                Text("Add a new Item")
                    .font(.title2)
                    .fontWeight(.light)
                    .navigationTitle("Hey User")

//                NavigationLink {
//                    InformationView(ViewRouter)
//                } label: {
//                    Text("Add Something")
//                }

            }
        }
    }

    init(navTitle: String) {
        self.navTitle = navTitle
    }
    init() {
        self.navTitle = "Hey User"
    }
}

struct NoItemsView_Previews: PreviewProvider {
    static var previews: some View {
        NoItemsView()
    }
}
