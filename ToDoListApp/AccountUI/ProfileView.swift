//
//  ProfileView.swift
//  ToDoListApp
//
//  Created by Md. Sadil Khan on 07/11/2022.
//

import SwiftUI

struct ProfileView: View {
    @AppStorage("firstName") var firstName: String?
    @AppStorage("middleName") var middleName: String?
    @AppStorage("lastName") var lastName: String?
    @AppStorage("Age") var age: Double?
    @AppStorage("isUserSignedIn") var isUserSignedIn: Bool?

    @State var currentFirstName: String = ""
    @State var currentMiddleName: String = ""
    @State var currentLastName: String = ""
    @State var currentAge: Double = 18


    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewRouter: ViewRouter

    // MARK: BODY VIEW
    var body: some View {
        VStack {
            Divider()
            // Profile Picture
            profilePicView
            Divider()
            // Basic Information
            basicInfomationView
            saveButton
            Spacer()
        }
            .onAppear {
            currentFirstName = firstName ?? ""
            currentMiddleName = middleName ?? ""
            currentLastName = lastName ?? ""
            currentAge = age ?? 18.0
        }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)

    }
}

// MARK: SOME MORE VIEWS
extension ProfileView {

    var basicInfomationView: some View {
        VStack {
            customText(title: "Basic Information")

            HStack {
                Text("First Name")
                Spacer()
                TextField("First Name", text: $currentFirstName)
//                    .onChange(of: currentFirstName, perform: { newValue in
//                    firstName = newValue
//                })
                .multilineTextAlignment(.trailing)
                    .frame(width: 100)

            }
            divider
            HStack {
                Text("Middle Name")
                Spacer()
                TextField("Middle Name", text: $currentMiddleName)
//                    .onChange(of: currentMiddleName, perform: { newValue in
//                    middleName = currentMiddleName
//                })
                .multilineTextAlignment(.trailing)
                    .frame(width: 120)
            }
            divider
            HStack {
                Text("Last Name")
                Spacer()
                TextField("Last Name", text: $currentLastName)
//                    .onChange(of: currentLastName, perform: { newValue in
//                    lastName = newValue
//                })
                .multilineTextAlignment(.trailing)
                    .frame(width: 100)
            }
            divider
            HStack {
                Text("Age")
                Spacer()
                Picker(selection: $currentAge) {
                    ForEach(18...100, id: \.self) { i in
                        Text("\(i)").tag(Double(i))
                    }
                } label: {
                    Text("Age")
                }
//                    .onChange(of: currentAge) { newValue in
//                    age = newValue
//                }
            }
        }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
    }

    var profilePicView: some View {
        VStack {
            customText(title: "Profile Picture")
            ZStack {
                Circle()
                    .stroke(.primary)
                    .frame(width: 100, height: 100)
                Image(systemName: "person.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.blue)
                    .frame(width: 50, height: 50)
            }.frame(maxWidth: .infinity, alignment: .leading)
        }.padding(.horizontal, 20)
    }

    var divider: some View {
        Divider()
            .frame(height: 1.0)
    }


    var saveButton: some View {

        Button {
            firstName = currentFirstName
            middleName = currentMiddleName
            lastName = currentLastName
            age = currentAge
            presentationMode.wrappedValue.dismiss()
        } label: {
            Text("Save")
                .font(.title2)
                .foregroundColor(.white)
                .fontWeight(.semibold)
                .padding()
                .background(editingChange() ? Color.gray.cornerRadius(20) : Color.blue.cornerRadius(20))
                .foregroundColor(.black)
        }
            .disabled(editingChange())

    }
}


// MARK: METHODS

extension ProfileView {

    func editingChange() -> Bool {
        if (firstName != currentFirstName) || (middleName != currentMiddleName) || (lastName != currentLastName) || (age != currentAge) {
            return false
        }
        return true
    }

    func customText(title: String) -> some View {
        Text(title)
            .font(.body)
            .fontWeight(.light)
            .foregroundColor(.secondary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom, 10)
    }
}

