//
//  TabIconView.swift
//  ToDoListApp
//
//  Created by Md. Sadil Khan on 03/11/2022.
//

import SwiftUI

/// Creates a Tab Icon
struct TabIconView: View {
    // MARK: DEFINING PROPERTIES
    @StateObject var viewRouter: ViewRouter
    let assignedPage: Page
    let width, height: CGFloat
    let systemIconName, tabName: String
    // MARK: MAIN BODY
    var body: some View {
        Button {
            withAnimation(.spring(response: 0.7, dampingFraction: 0.5)) {
                viewRouter.currentPage = assignedPage
                viewRouter.animationActiveButton(assignedPage)
            }
        } label: {
            VStack {
                Image(systemName: systemIconName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: width, height: height)
                    .padding(.top, 20)
                    .rotation3DEffect(viewRouter.isActive[assignedPage] ?? false ? .degrees(0) : .degrees(360), axis: (x: 0, y: 1, z: 0))
                //.rotationEffect(Angle(degrees: clicked ? 360 : 0))
                .offset(y: viewRouter.isActive[assignedPage] ?? false ? 0 : 20)
                Text(tabName)
                    .font(.footnote)
                    .opacity(viewRouter.isActive[assignedPage] ?? false ? 1 : 0)
                Spacer()

            }
        }
            .padding(.horizontal, -4)
        //            .onTapGesture {
        //            viewRouter.currentPage = assignedPage
        //        }
        .foregroundColor(viewRouter.currentPage == assignedPage ? .blue : .gray.opacity(0.5))
    }
}

