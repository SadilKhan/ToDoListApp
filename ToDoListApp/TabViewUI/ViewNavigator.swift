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
    @Published var isActive: [Page:Bool]=[.home:true,.analytics:false]
    @Published var showNavigator:Bool = true
    
    
    /// Method to activate animation for the selected tab
    /// - Parameter activatePage: The current active page
    func animationActiveButton(_ activatePage: Page){
        for (key,_) in isActive{
            if key == activatePage {
                isActive[key]=true
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
}

