import SwiftUI

/// Main Page

// MARK: MAIN PAGE
struct ContentView: View {

    // MARK: PROPERTIES
    @StateObject var itemDataBase: ItemDB = ItemDB()
    @ObservedObject var viewRouter: ViewRouter = ViewRouter()

    // MARK: The stored files for user input
    @AppStorage("firstName") var firstName: String?
    @AppStorage("middleName") var middleName: String?
    @AppStorage("lastName") var lastName: String?
    @AppStorage("Age") var age: Double?
    @AppStorage("isUserSignedIn") var isUserSignedIn: Bool?

    // MARK: BODY
    var body: some View {
        // If the user is signed in go to MainView else welcome
        if isUserSignedIn ?? false {
            mainView
                .environmentObject(itemDataBase)
        } else {
            SignUpView(viewRouter: viewRouter)
        }
    }
}


extension ContentView {

    // MARK: The Main View for adding Tasks
    var mainView: some View {
        GeometryReader {
            geometry in
            VStack {
                Spacer()
                switch self.viewRouter.currentPage {
                case .home:
                    TaskView(navTitle: "Hey \(firstName ?? "User")", viewRouter: viewRouter)
                        .onAppear {
                        self.viewRouter.showNavigator = true
                    }
                    //.transition(.move(edge:.leading))
                case .analytics:
                    AnalyticsView()
//                        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                case .account:
                    AccountMenuView(viewRouter: viewRouter)
                    //.transition(.move(edge:.trailing))
                }
                Spacer()
                if viewRouter.showNavigator {
                    HStack {
                        Spacer()
                        TabIconView(viewRouter: viewRouter, assignedPage: .home, width: geometry.size.width / 5, height: geometry.size.height / 28, systemIconName: "house.fill", tabName: "Home")
                        Spacer()

                        TabIconView(viewRouter: viewRouter, assignedPage: .analytics, width: geometry.size.width / 5, height: geometry.size.height / 28, systemIconName: "chart.bar.fill", tabName: "Analytics")
                        Spacer()
                        TabIconView(viewRouter: viewRouter, assignedPage: .account, width: geometry.size.width / 5, height: geometry.size.height / 28, systemIconName: "person.fill", tabName: "Account")
                        Spacer()
                    }
                        .frame(width: geometry.size.width, height: geometry.size.height / 20)
                        .ignoresSafeArea(.all, edges: .top)
                }

            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
