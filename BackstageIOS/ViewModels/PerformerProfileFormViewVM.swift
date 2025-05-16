//
//  PerformerProfileFormViewVM.swift
//  BackstageIOS
//
//  Created by Reinis Rudens on 17/05/2025.
//

import Foundation
import FirebaseFirestore

@Observable
class PerformerProfileFormViewVM {
  var appController: AppController
  private let existingProfileId: String?

  var name: String = ""
  var description: String = ""
  var memberCount: Int = 1
  var genres: [String] = []
  var contactEmail: String = ""
  var contactPhone: String = ""

  init(appController: AppController) {
    self.appController = appController
    self.existingProfileId = nil
  }

  init(appController: AppController, profile: PerformerProfile) {
    self.appController = appController
    self.existingProfileId = profile.id
    patchProfile(profile: profile)
  }

  func createProfile() {
    guard let user = appController.user, appController.isPerformer() else {
      print("No logged-in user.")
      return
    }

    let db = Firestore.firestore()
    let now = Date().timeIntervalSince1970
    let docRef = db.collection("performerProfiles").document()

    let newProfile = PerformerProfile(
      id: docRef.documentID,
      userId: user.id,
      name: name,
      description: description,
      memberCount: memberCount,
      genres: genres,
      contactEmail: contactEmail,
      contactPhone: contactPhone,
      createdAt: now,
      updatedAt: now
    )

    docRef.setData(newProfile.asDict())
  }

  func updateProfile() {
    guard let user = appController.user else {
      print("No logged-in user.")
      return
    }

    guard let profileId = existingProfileId else {
      print("Can't update profile, no profileId!")
      return
    }

    let db = Firestore.firestore()
    let now = Date().timeIntervalSince1970
    let docRef = db.collection("performerProfiles").document(profileId)

    let updatedProfile = PerformerProfile(
      id: profileId,
      userId: user.id,
      name: name,
      description: description,
      memberCount: memberCount,
      genres: genres,
      contactEmail: contactEmail,
      contactPhone: contactPhone,
      createdAt: -1,
      updatedAt: now
    )

    docRef.updateData([
      "name": updatedProfile.name,
      "description": updatedProfile.description,
      "memberCount": updatedProfile.memberCount,
      "genres": updatedProfile.genres,
      "contactEmail": updatedProfile.contactEmail as Any,
      "contactPhone": updatedProfile.contactPhone as Any,
      "updatedAt": updatedProfile.updatedAt
    ])
  }

  private func patchProfile(profile: PerformerProfile) {
    name = profile.name
    description = profile.description
    memberCount = profile.memberCount
    genres = profile.genres
    contactEmail = profile.contactEmail ?? ""
    contactPhone = profile.contactPhone ?? ""
  }
}
