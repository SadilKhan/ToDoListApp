//
//  NoItemsView.swift
//  ToDoListApp
//
//  Created by Md. Sadil Khan on 02/11/2022.
//

import SwiftUI

struct NoItemsView: View {
    @State var navTitle: String = "Hey Sadil"
    @State var isAnimated: Bool = false
    @ObservedObject var viewRouter: ViewRouter
    var body: some View {
        NavigationView {
            VStack {
                //Spacer()
                Text("Do you want to have a productive day? Add some new tasks to get going.")
                    .font(.title)
                    .fontWeight(.light)
                    .frame(width: 300)
                    .padding(.top,30)
                NavigationLink {
                    InformationView(viewRouter)
                } label: {
                    Text("Get Started")
                        .foregroundColor(.white)
                        .padding()
                        .background(ColorsDB().buttonColor)
                        .cornerRadius(20)
                        .scaleEffect(isAnimated ? 1.2 : 1)
                        .shadow(color: ColorsDB().buttonColor.opacity(0.8), radius: 20, x: 10, y: 20)
                        .onAppear {
                            withAnimation(.easeInOut(duration: 1.5).repeatForever()) {
                            isAnimated.toggle()
                        }
                    }
                }
                Spacer()
            }
                .navigationTitle(navTitle)
        }
    }

//init(navTitle: String) {
//    self.navTitle = navTitle
//}
//init() {
//    self.navTitle = "Hey User"
//}
}

struct NoItemsView_Previews: PreviewProvider {
    static var previews: some View {
        NoItemsView(viewRouter: ViewRouter())
    }
}
