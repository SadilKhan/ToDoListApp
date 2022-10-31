//
//  SearchView.swift
//  ToDoListApp
//
//  Created by Md. Sadil Khan on 31/10/2022.
//

import SwiftUI

struct SearchView: View {
    @State var searchText:String=""
    var body: some View {
        TextField(text: $searchText) {
            HStack{
                Image(systemName: "plus")
                Text("Search")
            }
        }
        .padding(10)
    }
}



struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
