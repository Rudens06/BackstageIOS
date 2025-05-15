//
//  NewEventVM.swift
//  BackstageIOS
//
//  Created by Reinis Rudens on 15/05/2025.
//

import Foundation
import Observation
import FirebaseFirestore
import FirebaseAuth

@Observable
class NewEventViewVM {
  var appController: AppController

  init(appController: AppController) {
    self.appController = appController
  }

  var eventName: String = ""
  var eventDescription: String = ""
  var startDate: Date = Date()
  var endDate: Date = Date()
  var venue: String = ""
  var createdAt: Date = Date()
  var updatedAt: Date = Date()


  func createEvent() {
    guard let user = appController.user else {
      print("No logged-in user.")
      return
    }

    let db = Firestore.firestore()

    let now = Date().timeIntervalSince1970
    let docRef = db.collection("events").document()

    let newEvent = Event(
      id: docRef.documentID,
      name: eventName,
      description: eventDescription,
      organizerId: user.id,
      organizerName: user.name,
      startDate: startDate.timeIntervalSince1970,
      endDate: endDate.timeIntervalSince1970,
      venue: venue,
      createdAt: now,
      updatedAt: now
    )

    docRef.setData(newEvent.asDict())
  }
}
