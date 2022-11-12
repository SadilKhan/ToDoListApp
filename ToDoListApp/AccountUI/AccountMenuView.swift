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
    @EnvironmentObject var itemDataBase: ItemViewModel

    var body: some View {
        NavigationView { // NAV START
            VStack {
                Text("Account")
                    .fontWeight(.bold)
                List { // LIST START
                    profileSection
                    developerSection
                    signSection
                } // LIST END
                .listStyle(.automatic)
                    .navigationBarTitle("", displayMode: .inline)
                    .navigationBarHidden(true)
            }
            //.navigationBarTitleDisplayMode(.inline)
        }// NAV END

    }
}


extension AccountMenuView {
    private var profileSection: some View {
        Section {
            NavigationLink {
                ProfileView(viewRouter: viewRouter)
            } label: {
                Text("Profile")
            }
        } header: {
            Text("User Information")
        }

    }

    private var developerSection: some View {
        Section {
            helpLink
            Link("About Developer", destination: URL(string: "https://mdsadilkhan.netlify.app/")!)
        } header: {
            Text("Link")
        }
    }

    private var signSection: some View {
        Section {
            signedOutButton
        } header: {
            Text("Sign out")
        }
    }

    private var signedOutButton: some View {
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

    private var helpLink: some View {
        Link("Help", destination: URL(string: "https://github.com/SadilKhan/ToDoListApp")!)
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
                ItemViewModel.saveData(allItems: itemDataBase.allItems) { result in
                    if case .failure(let error) = result {
                        let _ = print(error.localizedDescription)
                    }
                }
                ItemViewModel.saveAllDone(allDone: itemDataBase.allDone) { result in
                    if case .failure(let error) = result {
                        let _ = print(error.localizedDescription)
                    }
                }
                ItemViewModel.saveShowSection(showSection: itemDataBase.showSection) { result in
                    if case .failure(let error) = result {
                        let _ = print(error.localizedDescription)
                    }
                }
                itemDataBase.reset()
                self.viewRouter.changeActiveButton(.home)
                withAnimation(.easeInOut(duration: 0.5)) {
                    signOut()
                }
            },
            secondaryButton: .cancel()
        )
    }
}
