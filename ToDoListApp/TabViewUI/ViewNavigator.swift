//
//  ViewNavigator.swift
//  ToDoListApp
//
//  Created by Md. Sadil Khan on 03/11/2022.
//

import SwiftUI

/// This class maintains the current page view and navigates to another page by changing currentPage variable
class ViewRouter: ObservableObject {

    @Published var currentPage: Page = .home
    @Published var isActive: [Page: Bool] = [.home: true, .analytics: false, .account: false]
    @Published var showNavigator: Bool = true


    /// Chages the active tab view
    /// - Parameter activatePage: The current active page
    func changeActiveButton(_ activePage: Page) {
        currentPage = activePage
        for (key, _) in isActive {
            if key == activePage {
                isActive[key] = true
            } else {
                isActive[key] = false
            }
        }
    }


}

/// This enum contains all the tab views
enum Page {

    case home
    case analytics
    case account
}

