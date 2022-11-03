import SwiftUI

/// Main Page

// MARK: MAIN PAGE
struct ContentView: View {

    // MARK: PROPERTIES
    @StateObject var itemDataBase: ItemDB = ItemDB()
    @ObservedObject var viewRouter: ViewRouter = ViewRouter()

    // MARK: BODY
    var body: some View {
        GeometryReader {
            geometry in
            VStack {
                Spacer()
                switch self.viewRouter.currentPage {
                case .home:
                    HomeView(viewRouter: viewRouter)
                        .onAppear {
                        self.viewRouter.showNavigator = true
                    }

                case .analytics:
                    AnalyticsView()
                }
                Spacer()
                if viewRouter.showNavigator {
                    HStack {
                        Spacer()
                        TabIconView(viewRouter: viewRouter, assignedPage: .home, width: geometry.size.width / 5, height: geometry.size.height / 28, systemIconName: "house.fill", tabName: "Home")
                        Spacer()

                        TabIconView(viewRouter: viewRouter, assignedPage: .analytics, width: geometry.size.width / 5, height: geometry.size.height / 28, systemIconName: "chart.bar.fill", tabName: "Analytics")
                        Spacer()
                    }
                        .frame(width: geometry.size.width, height: geometry.size.height / 20)
                        .ignoresSafeArea(.all, edges: .top)
                }

            }
        }
            .animation(.easeInOut(duration: 0.5), value: itemDataBase.allKeys)
            .environmentObject(itemDataBase)

    }


}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
