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
            // Rive Background Animation
            RiveViewModel(fileName: "background").view()
                .blur(radius: 40)
                .ignoresSafeArea()
                .background(
                Image("Spline")
                    .blur(radius: 50)
                    .offset(x: 200, y: 100)
            )
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(.ultraThinMaterial)
                    .frame(width: 350, height: 500)
                VStack {
                    RiveViewModel(fileName: "tidi").view()
                        .frame(height: 300)
                    Text("Do you want to have a productive day? Sign Up to add some new tasks and get going.")
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
                            .frame(width: 200)
                            .padding()
                            .background(isAnimated ? ColorsDB().buttonColor : ColorsDB().buttonColotNotAnimated)
                            .cornerRadius(20)
                            .scaleEffect(isAnimated ? 1.2 : 1)
                            .shadow(color: isAnimated ? ColorsDB().buttonColor : ColorsDB().buttonColotNotAnimated.opacity(0.8), radius: isAnimated ? 25 : 5, x: 0, y: isAnimated ? 30 : 20)
                            .onAppear {
                            withAnimation(.easeInOut(duration: 2).repeatForever()) {
                                isAnimated.toggle()
                            }
                        }
                    }
                    Spacer()
                }
            }
        }
    }
}

