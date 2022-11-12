import SwiftUI

/// Main Page

// MARK: MAIN PAGE
struct ContentView: View {

    // MARK: PROPERTIES
    @StateObject var itemDataBase: ItemViewModel = ItemViewModel()
    @ObservedObject var viewRouter: ViewRouter = ViewRouter()
    @State var searchText: String = ""
    @Environment(\.scenePhase) var scenePhase
    @State var isTabSwiped: Bool = false

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
            // Load Data when the view appears
            .onAppear {
                ItemViewModel.loadData { result in
                    switch result {
                    case .failure(let error):
                        let _ = print(error.localizedDescription)
                    case .success(let decodedData):
                        //itemDataBase.allItems = decodedData
                        itemDataBase.allItems = decodedData
                        itemDataBase.allKeys = Array(decodedData.keys)
                        //let _ = print(decodedData.keys)
                        for (key, value) in itemDataBase.allItems {
                            itemDataBase.updateDateMap(value, key, false)
                        }
                    }
                }
                ItemViewModel.loadAllDone { result in
                    switch result {
                    case .failure(let error):
                        let _ = print(error.localizedDescription)
                    case .success(let decodedData):
                        itemDataBase.allDone = decodedData
                    }
                }
                ItemViewModel.loadShowSection { result in
                    switch result {
                    case .failure(let error):
                        let _ = print(error.localizedDescription)
                    case .success(let decodedData):
                        itemDataBase.showSection = decodedData
                    }
                }
            }
                .environmentObject(itemDataBase)
        } else {
            SignUpView(viewRouter: viewRouter)
        }
    }
}


extension ContentView {

    // MARK: The Main View for adding Tasks
    private var mainView: some View {
        GeometryReader {
            geometry in
            VStack {
                Spacer()
                switch self.viewRouter.currentPage {
                    // Home Page
                case .home:
                    TaskView(navTitle: "Hi \(firstName ?? "User")",
                        searchText: $searchText,
                        viewRouter: viewRouter)
                        .transition(.asymmetric(insertion: .opacity.animation(.easeOut(duration: 0.5)), removal: .opacity.animation(.easeIn(duration: 0.5))))
                        .onAppear {
                        self.viewRouter.showNavigator = true
                    }
                        .onChange(of: scenePhase) { newValue in
                        if newValue == .inactive {
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

                        }
                    }
//                        .onChange(of: itemDataBase.showSection) { newValue in
//                        ItemViewModel.saveShowSection(showSection: newValue) { result in
//                            if case .failure(let error) = result {
//                                let _ = print(error.localizedDescription)
//                            }
//                        }
//                    }
                    // Analytics Page
                case .analytics:
                    AnalyticsView(
                        searchText: $searchText,
                        viewRouter: viewRouter)
                    // Account Page
                case .account:
                    AccountMenuView(viewRouter: viewRouter)
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
            // Gesture to swipe across various tabs
            .gesture(
                DragGesture()
                    .onChanged({ offset in
                    if offset.translation.width < -100 {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            if self.viewRouter.currentPage == .home && !isTabSwiped {
                                isTabSwiped = true
                                self.viewRouter.changeActiveButton(.analytics)
                            } else if self.viewRouter.currentPage == .analytics && !isTabSwiped {
                                isTabSwiped = true
                                self.viewRouter.changeActiveButton(.account)
                            }
                        }
                    }
                    else if offset.translation.width > 100 {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            if self.viewRouter.currentPage == .analytics && !isTabSwiped {
                                isTabSwiped = true
                                self.viewRouter.changeActiveButton(.home)
                            } else if self.viewRouter.currentPage == .account && !isTabSwiped {
                                isTabSwiped = true
                                self.viewRouter.changeActiveButton(.analytics)
                            }
                        }
                    }

                })
                    .onEnded({ offset in
                    isTabSwiped = false
                })
            )
        }
    }



}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
