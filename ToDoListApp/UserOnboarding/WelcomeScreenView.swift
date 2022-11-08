//
//  NoItemsView.swift
//  ToDoListApp
//
//  Created by Md. Sadil Khan on 02/11/2022.
//

import SwiftUI
import RiveRuntime

struct WelcomeScreenView: View {
    @State var navTitle: String = "Hey Sadil"
    @State var isAnimated: Bool = false
    @State var openInFoView: Bool = true
    @Binding var onBoadingState: OnBoadingStateType
    @Binding var pageMovingDirection: PageDirection
    var body: some View {
        ZStack {
            RiveViewModel(fileName: "background").view()
                .blur(radius: 50)
                .ignoresSafeArea()
                .background(
                Image("Spline")
                    .blur(radius: 50)
                    .offset(x: 200, y: -100)
            )
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(.white.opacity(0.2))
                    .frame(width: 350, height: 500)
                VStack {
                    Spacer()
                    Text("Do you want to have a productive day? Sign Up and add some new tasks to get going.")
                        .font(.title)
                        .fontWeight(.light)
                        .frame(width: 300)
                        .padding(.top, 30)
                    Button {
                        //SignUpView(viewRouter: viewRouter)
                        pageMovingDirection = .next
                        withAnimation(.easeInOut(duration: 0.5)) {
                            onBoadingState = .nameField
                        }
                    } label: {
                        Text("Sign Up")
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
            }
            //.navigationTitle(navTitle)
        }
    }
}

