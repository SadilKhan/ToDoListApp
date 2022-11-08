//
//  ToDoListAppApp.swift
//  ToDoListApp
//
//  Created by Md. Sadil Khan on 31/10/2022.
//

import SwiftUI

@main
struct ToDoListAppApp: App {
    @StateObject var itemDataBase: ItemDB = ItemDB()
    var body: some Scene {
        WindowGroup {
            ContentView()
                
        }
    }
}
