//
//  AccountMenuView.swift
//  ToDoListApp
//
//  Created by Md. Sadil Khan on 08/11/2022.
//

import SwiftUI

struct AccountMenuView: View {
    @AppStorage("firstName") var firstName: String?
    @AppStorage("middleName") var middleName: String?
    @AppStorage("lastName") var lastName: String?
    @AppStorage("Age") var age: Double?

    @AppStorage("isUserSignedIn") var isUserSignedIn: Bool?
    @ObservedObject var viewRouter: ViewRouter
    @State var showSignOutAlert: Bool = false

    var body: some View {
        NavigationView { // NAV START
            List { // LIST START
                NavigationLink {
                    ProfileView(viewRouter: viewRouter)
                } label: {
                    Text("Profile")
                }
                signedOutButton
            } // LIST END
            .navigationTitle("Account")
                //.navigationBarTitleDisplayMode(.inline)
        } // NAV END
    }
}


extension AccountMenuView {


    var signedOutButton: some View {
        Button {
            // Set the active button to home so that next time, the user signs in, home will the first page
            showSignOutAlert.toggle()


        } label: {
            Text("Sign out")
        }
            .alert(isPresented: $showSignOutAlert) {
            signOutAlert()
        }
    }
}
// MARK: METHODS
extension AccountMenuView {

    func signOut() {
        firstName = nil
        middleName = nil
        lastName = nil
        age = nil
        isUserSignedIn = false
    }

    func signOutAlert() -> Alert {
        Alert(
            title: Text("Are you sure you want to sign out?"),
            message: Text("Signing out will delete all your information. This action is irreversible."),
            primaryButton: .destructive(Text("Sign out")) {
                self.viewRouter.changeActiveButton(.home)
                withAnimation(.easeInOut(duration: 0.5)) {
                    signOut()
                }
            },
            secondaryButton: .cancel()
        )
    }
}
