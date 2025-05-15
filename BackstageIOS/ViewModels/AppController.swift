//
//  AppControler.swift
//  BackstageIOS
//
//  Created by Reinis Rudens on 15/05/2025.
//

import SwiftUI
import Observation
import FirebaseAuth
import FirebaseFirestore

enum AuthState {
  case undefinded
  case authenticated
  case unauthenticated
}

@Observable
class AppController {
  var email = ""
  var password = ""
  var name = ""
  var userType: User.UserType = .organizer

  var user: User?

  var authState: AuthState = .undefinded

  func listenToAuthChanges() {
    Auth.auth().addStateDidChangeListener { auth, user in
      self.authState = user != nil ? .authenticated : .unauthenticated
    }
  }

  func signUp() throws {
    Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
      guard let userId = result?.user.uid, error == nil else {
        return
      }

      self?.createUser(id: userId)
    }
  }

  func signIn() async throws{
    _ = try await Auth.auth().signIn(withEmail: email, password: password)
  }

  func signOut() throws {
    try Auth.auth().signOut()
    resetUserFields()
    authState = .unauthenticated
    resetUser()
  }

  func createUser(id: String) {
    let newUser = User(id: id, name: name, email: email, joined: Date().timeIntervalSince1970, userType: userType)

    let db = Firestore.firestore()

    db.collection("users")
      .document(id)
      .setData(newUser.asDict())
  }

  func fetchUser() {
    guard let userId = Auth.auth().currentUser?.uid else { return }

    let db = Firestore.firestore()

    let docRef = db.collection("users").document(userId)

    docRef.getDocument { [weak self] document, error in
      guard let document = document, error == nil else { return }

      do {
        let userData = try document.data(as: User.self)

        DispatchQueue.main.async {
          self?.user = userData
        }
      } catch {
        print("Error decoding user: \(error)")
      }
    }
  }

  private func resetUserFields() {
    name = ""
    email = ""
    password = ""
    userType = .organizer
  }

  private func resetUser() {
    user = nil
  }
}
