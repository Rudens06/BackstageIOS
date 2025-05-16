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
class EventFormViewVM {
  var appController: AppController
  private let existingEventId: String?

  init(appController: AppController) {
    self.appController = appController
    self.existingEventId = nil
  }

  init(appController: AppController, event: Event) {
    self.appController = appController
    self.existingEventId = event.id
    patchEvent(event: event)
  }

  var name: String = ""
  var description: String = ""
  var startDate: Date = Date()
  var endDate: Date = Date()
  var venue: String = ""
  var performers: [String] = []
  var createdAt: Date = Date()
  var updatedAt: Date = Date()

  func createEvent() {
    guard let user = appController.user, appController.isOrganizer() else {
      print("No logged-in user.")
      return
    }

    let db = Firestore.firestore()
    let now = Date().timeIntervalSince1970
    let docRef = db.collection("events").document()

    let newEvent = Event(
      id: docRef.documentID,
      name: name,
      description: description,
      organizerId: user.id,
      organizerName: user.name,
      startDate: startDate.timeIntervalSince1970,
      endDate: endDate.timeIntervalSince1970,
      venue: venue,
      performers: performers,
      createdAt: now,
      updatedAt: now
    )

    docRef.setData(newEvent.asDict())
  }

  func updateEvent() {
    guard let user = appController.user, appController.isOrganizer() else {
      print("No logged-in user.")
      return
    }

    guard let eventId = existingEventId else {
      print("can't update event, no eventId!")
      return
    }

    let db = Firestore.firestore()
    let now = Date().timeIntervalSince1970
    let docRef = db.collection("events").document(eventId)

    let updatedEvent = Event(
          id: eventId,
          name: name,
          description: description,
          organizerId: user.id,
          organizerName: user.name,
          startDate: startDate.timeIntervalSince1970,
          endDate: endDate.timeIntervalSince1970,
          venue: venue,
          performers: performers,
          createdAt: -1,
          updatedAt: now
        )

    docRef.updateData([
      "name": updatedEvent.name,
      "description": updatedEvent.description,
      "startDate": updatedEvent.startDate,
      "endDate": updatedEvent.endDate,
      "venue": updatedEvent.venue,
      "performers": updatedEvent.performers,
      "updatedAt": updatedEvent.updatedAt
    ])
  }

  private func patchEvent(event: Event) {
    name = event.name
    description = event.description
    startDate = Date(timeIntervalSince1970: event.startDate)
    endDate = Date(timeIntervalSince1970: event.endDate)
    venue = event.venue
    performers = event.performers
  }
}
