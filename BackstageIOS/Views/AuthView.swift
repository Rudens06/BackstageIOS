//
//  AuthView.swift
//  BackstageIOS
//
//  Created by Reinis Rudens on 15/05/2025.
//

import SwiftUI

struct AuthView: View {
  @Environment(AppController.self) private var appControler

  @State private var isSignUp = false

  var body: some View {
    VStack {
      Text("BackStage")
        .font(.largeTitle)
        .bold()
        .padding(.bottom, 20)

      Text("Welcome to BackStage!")
        .font(.headline)
        .padding(.bottom, 10)

      Text("Log in to your account")
        .font(.subheadline)
        .padding(.bottom, 20)

      if isSignUp {
        signUpForm()
      } else {
        signInForm()
      }

      Button {
        authenticate()
      } label: {
        HStack {
          Spacer()
          Text("\(isSignUp ? "Sign Up" : "Log In")")
          Spacer()
        }
      }
      .buttonStyle(.borderedProminent)

      Button("\(isSignUp ? "I already have an account" : "I don't have an account")") {
        isSignUp.toggle()
      }
      .padding(.top, 10)
      Spacer()
     }
    .padding(.top, 100)
    .padding(.horizontal, 20)
  }

  private func signInForm() -> some View {
    VStack {
      BSTextField(text: Bindable(appControler).email, placeholder: "Email", image: "envelope")
        .textInputAutocapitalization(.never)
      BSTextField(text: Bindable(appControler).password, placeholder: "Password", image: "lock", isSecure: true)
    }
  }

  private func signUpForm() -> some View {
    VStack {
      BSTextField(text: Bindable(appControler).name, placeholder: "Name", image: "person")
      BSTextField(text: Bindable(appControler).email, placeholder: "Email", image: "envelope")
        .textInputAutocapitalization(.never)
      BSTextField(text: Bindable(appControler).password, placeholder: "Password", image: "lock", isSecure: true)

      VStack(alignment: .leading) {
        Text("Select user type")
          .font(.footnote)
          .foregroundStyle(.secondary)
          .padding(.leading, 4)

        Picker("User type", selection: Bindable(appControler).userType) {
          Text("Performer").tag(User.UserType.performer)
          Text("Event Organizer").tag(User.UserType.organizer)
          Text("Technician").tag(User.UserType.technician)
        }
        .foregroundStyle(.secondary)
        .pickerStyle(.menu)
        .frame(maxWidth: .infinity)
        .padding(4)
        .background(
          RoundedRectangle(cornerRadius: 8)
            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
        )
      }
      .padding(.vertical, 4)
    }
  }

  private func authenticate() {
    isSignUp ? signUp() : signIn()
  }

  private func signUp() {
    do {
      try appControler.signUp()
    } catch {
      print("Error signing up: \(error.localizedDescription)")
    }
  }

  private func signIn() {
    Task {
      do {
        try await appControler.signIn()
      } catch {
        print("Error signing in: \(error.localizedDescription)")
      }
    }
  }

}

#Preview {
  AuthView().environment(AppController())
}
