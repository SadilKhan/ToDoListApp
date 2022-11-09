//
//  SignUpView.swift
//  ToDoListApp
//
//  Created by Md. Sadil Khan on 07/11/2022.
//

import SwiftUI

enum OnBoadingStateType {

    case welcomeScreen
    case nameField
    case ageField
}

enum PageDirection {

    case previous
    case next
}

/// This creates pages for signing up
struct SignUpView: View {

    // MARK: SAVED LOGGED IN INFORMATION
    @AppStorage("firstName") var firstName: String?
    @AppStorage("middleName") var middleName: String?
    @AppStorage("lastName") var lastName: String?
    @AppStorage("Age") var age: Double?
    @AppStorage("isUserSignedIn") var isUserSignedIn: Bool?

    // PLACEHOLDERS FOR TEXTFIELD
    @State private var currentFirstName: String = ""
    @State private var currentMiddleName: String = ""
    @State private var currentLastName: String = ""
    @State private var currentAge: Double = 18

    // OTHER
    @State private var showNameAlert: Bool = false
    @State private var alertTitle: String = ""
    @State private var onBoadingState: OnBoadingStateType = .welcomeScreen
    @ObservedObject var viewRouter: ViewRouter
    @State private var pageMovingDirection: PageDirection = .next
    @FocusState private var isUserInFocus: Bool



    var body: some View {
        switch onBoadingState {
        case .welcomeScreen:
            // Welcome Screen
            WelcomeScreenView(onBoadingState: $onBoadingState, pageMovingDirection: $pageMovingDirection)
                .transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .leading)))
        case .nameField:
            // Name Screen
            nameView
                .transition(.asymmetric(insertion: pageMovingDirection == .next ? .move(edge: .trailing) : .move(edge: .leading), removal: pageMovingDirection == .next ? .move(edge: .leading) : .move(edge: .trailing)))
                .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.isUserInFocus.toggle()
                }
            }
        case .ageField:
            // Age Screen
            ageView
                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .opacity.animation(.easeIn(duration: 0.5))))
        }
    }
}

// MARK: PROPERTIES
extension SignUpView {

    var nameView: some View {
        ZStack {
            //iPhone 14 Pro Max - 1
            Rectangle()
                .fill(LinearGradient(
                gradient: Gradient(stops: [
                        .init(color: Color(#colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)), location: 0),
                        .init(color: Color(#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)), location: 1)]),
                startPoint: UnitPoint(x: 1.6301228034087956e-8, y: -0.03648068854461087),
                endPoint: UnitPoint(x: 0.7302326617377309, y: 1.2049356576431123)))
                .ignoresSafeArea()

            VStack {
                signUpBackButton
                Spacer()
                // Title
                Text("What's your name?")
                    .font(.system(.largeTitle, design: .rounded))
                    .fontWeight(.semibold)
                    .foregroundColor(.white)

                // First Name Text Field
                createNameView(nameVariable: $currentFirstName, defaultText: "First Name (Required)")
                    .focused($isUserInFocus)
                // Middle Name Text Field
                createNameView(nameVariable: $currentMiddleName, defaultText: "Middle Name (Optional)")
                // Last Name Text Field
                createNameView(nameVariable: $currentLastName, defaultText: "Last Name (Optional)")
                Spacer()
                nextPageButton

            }
        }
    }

    var nextPageButton: some View {
        Button {
            buttonAction()
        } label: {
            ZStack {
                Text(onBoadingState == .nameField ? "Next" : "Finish")
                    .font(.title)
                    .fontWeight(.semibold)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.white.cornerRadius(20))
                    .padding(.horizontal, 20)
                    .foregroundColor(.black)
            }
        }
            .alert(isPresented: $showNameAlert) {
            Alert(title: Text(alertTitle))
        }

    }

    var ageView: some View {
        ZStack {
            //iPhone 14 Pro Max - 1
            Rectangle()
                .fill(LinearGradient(
                gradient: Gradient(stops: [
                        .init(color: Color(#colorLiteral(red: 0.5818830132, green: 0.2156915367, blue: 1, alpha: 1)), location: 0),
                        .init(color: Color(#colorLiteral(red: 0.8446564078, green: 0.5145705342, blue: 1, alpha: 1)), location: 1)]),
                startPoint: UnitPoint(x: 1.6301228034087956e-8, y: -0.03648068854461087),
                endPoint: UnitPoint(x: 0.7302326617377309, y: 1.2049356576431123)))
                .ignoresSafeArea()

            VStack {
                signUpBackButton
                Spacer()
                // Title
                Text("What's your age?")
                    .font(.system(.largeTitle, design: .rounded))
                    .fontWeight(.semibold)
                    .foregroundColor(.white)

                Text(String(format: "%.0f", currentAge))
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)

                Slider(value: $currentAge, in: 18...100, step: 1)
                    .tint(.white)
                    .padding(.horizontal, 20)
                Spacer()
                nextPageButton

            }
        }
    }

    var signUpBackButton: some View {
        Button {
            pageMovingDirection = .previous
            withAnimation(.easeInOut(duration: 0.5)) {
                changeOnBoadingStatePrevious(currentState: onBoadingState)
            }
        } label: {
            HStack {
                Image(systemName: "chevron.backward.circle")
                    .foregroundColor(.white)
                Text("Back")
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                Spacer()
            }
                .padding(.leading, 20)
        }

    }
}

// MARK: METHODS
extension SignUpView {

    /// Stores the user input values in devices for sign in
    func sign_in() {
        firstName = currentFirstName
        middleName = currentMiddleName
        lastName = currentLastName
        age = currentAge
        isUserSignedIn = true
    }

    /// Button action for sign up pages
    func buttonAction() {
        switch onBoadingState {
        case .nameField:
            guard currentFirstName.count >= 3 else {
                alertTitle = "First name must be at least 3 characters long"
                showNameAlert.toggle()
                return
            }
        case .ageField:
            sign_in()
        default:
            break
        }
        pageMovingDirection = .next
        withAnimation(.easeInOut(duration: 0.5)) {
            changeOnBoadingStateNext(currentState: onBoadingState)
        }
    }

    /// Changes to the the sign up pages
    /// - Parameter currentState: Requires the current sign up page
    func changeOnBoadingStateNext(currentState: OnBoadingStateType) {
        switch currentState {
        case .welcomeScreen:
            onBoadingState = .welcomeScreen
        case .nameField:
            onBoadingState = .ageField
        case .ageField:
            onBoadingState = .welcomeScreen
        }
    }

    /// Goes to previous sign up page
    /// - Parameter currentState: Requires the current sign up page
    func changeOnBoadingStatePrevious(currentState: OnBoadingStateType) {
        switch currentState {
        case .welcomeScreen:
            onBoadingState = .welcomeScreen
        case .nameField:
            onBoadingState = .welcomeScreen
        case .ageField:
            onBoadingState = .nameField
        }
    }

}

struct createNameView: View {
    @Binding var nameVariable: String
    @State var defaultText: String
    var body: some View {
        // First Name text field
        VStack {
            TextField(defaultText, text: $nameVariable)
                .padding()
                .background(
                RoundedRectangle(cornerRadius: 20)
                    //.fill(.white)
                    .fill(.thickMaterial)
                    .opacity(0.5)
            )
                .padding(.horizontal, 20)
        }
    }

}

