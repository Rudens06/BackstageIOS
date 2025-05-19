//
//  PerformersViewVM.swift
//  BackstageIOS
//
//  Created by Reinis Rudens on 17/05/2025.
//

import Foundation
import FirebaseFirestore

@Observable
class PerformersViewVM {
  var performers: [PerformerProfile] = []

  func fetchPerformers() {
    let db = Firestore.firestore()

    db.collection("performerProfiles").getDocuments { (snapshot, error) in
      if let error = error {
        print("Error getting documents: \(error)")
      } else {
        self.performers = snapshot?.documents.compactMap { document in
          try? document.data(as: PerformerProfile.self)
        } ?? []
      }
    }
  }
}
