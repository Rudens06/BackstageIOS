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
  var performerProfile: PerformerProfile?

  var authState: AuthState = .undefinded

  func listenToAuthChanges() {
    _ = Auth.auth().addStateDidChangeListener { auth, user in
      self.authState = user != nil ? .authenticated : .unauthenticated
      if user != nil {
        self.fetchUser()
      } else {
        self.resetUser()
      }
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
        if userData.userType == .performer {
          self?.fetchPerformerProfile(userId: userId) { performerProfile in
            DispatchQueue.main.async {
              self?.performerProfile = performerProfile
            }
          }
        }

        DispatchQueue.main.async {
          self?.user = userData
        }
      } catch {
        print("Error decoding user: \(error)")
      }
    }
  }

  func fetchPerformerProfile(userId: User.ID, completion: @escaping (PerformerProfile?) -> Void) {
    let db = Firestore.firestore()

    db.collection("performerProfiles")
      .whereField("userId", isEqualTo: userId)
      .limit(to: 1)
      .getDocuments { snapshot, error in
        if let error = error {
          print("Error fetching profile: \(error)")
          completion(nil)
          return
        }

        guard let document = snapshot?.documents.first else {
          print("No profile found for userId: \(userId)")
          completion(nil)
          return
        }

        do {
          let profile = try document.data(as: PerformerProfile.self)
          completion(profile)
        } catch {
          print("Error decoding profile: \(error)")
          completion(nil)
        }
      }
  }

  func syncPerformerProfile(userId: User.ID) {
    fetchPerformerProfile(userId: userId) { performerProfile in
      DispatchQueue.main.async {
        self.performerProfile = performerProfile
      }
    }
  }

  func isOrganizer() -> Bool {
    user?.userType == .organizer
  }

  func isTechnician() -> Bool {
    user?.userType == .technician
  }

  func isPerformer() -> Bool {
    user?.userType == .performer
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
