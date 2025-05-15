//
//  EventsListViewVM.swift
//  BackstageIOS
//
//  Created by Reinis Rudens on 15/05/2025.
//

import Foundation
import Observation
import FirebaseFirestore

@Observable
class EventsViewVM {
  var events: [Event] = []

  func fetchEvents() {
    let db = Firestore.firestore()
    
    db.collection("events").getDocuments { (snapshot, error) in
      if let error = error {
        print("Error getting documents: \(error)")
      } else {
        self.events = snapshot?.documents.compactMap { document in
          try? document.data(as: Event.self)
        } ?? []
      }
    }
  }
}
