import SwiftUI

/// Main Page

// MARK: MAIN PAGE
struct ContentView: View {

    // MARK: PROPERTIES
    @StateObject var itemDataBase: ItemDB = ItemDB()

    // MARK: BODY
    var body: some View {
        TabView { // TAB START
            HomeView()
                .tabItem {
                    VStack{
                        Image(systemName: "house.fill")
                        Text("Home")
                    }
                }
            AnalyticsView()
                .tabItem {
                    VStack{
                        Image(systemName: "chart.bar.fill")
                        Text("Analytics")
                    }
                }
        } // TAB END
        .environmentObject(itemDataBase)
    }
    
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
