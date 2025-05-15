//
//  EventView.swift
//  BackstageIOS
//
//  Created by Reinis Rudens on 15/05/2025.
//

import SwiftUI

struct EventView: View {
  @State private var viewModel: EventViewVM!

  var body: some View {
    Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
  }

  init(event: Event) {
    self.viewModel = EventViewVM(event: event)
  }
}

#Preview {
  EventView(event: Event(
    id: "1",
    name: "Test Event",
    description: "This is a test event",
    organizerId: "123",
    organizerName: "Test Organizer",
    startDate: Date().timeIntervalSince1970,
    endDate: Date().timeIntervalSince1970,
    venue: "Test Venue",
    createdAt: Date().timeIntervalSince1970,
    updatedAt: Date().timeIntervalSince1970))
}
