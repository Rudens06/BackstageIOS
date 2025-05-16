//
//  EventsListView.swift
//  BackstageIOS
//
//  Created by Reinis Rudens on 15/05/2025.
//

import SwiftUI

struct EventsView: View {
  @Environment(AppController.self) private var appController
  @State private var viewModel = EventsViewVM()
  @State private var isShowingEventFormView = false
  @State private var editingEvent: Event? = nil

  var body: some View {
    NavigationStack {
      ZStack {
        if viewModel.events.isEmpty {
          noEventsView()
        } else {
          eventsList()
        }
      }
      .navigationTitle("Events")
      .toolbar {
        if appController.isOrganizer() {
          ToolbarItem(placement: .navigationBarTrailing) {
            Button {
              isShowingEventFormView = true
            } label: {
              Image(systemName: "plus")
            }
          }
        }
        ToolbarItem(placement: .navigationBarLeading) {
          Button {
            viewModel.fetchEvents()
          } label: {
            Image(systemName: "arrow.clockwise")
          }
        }
      }
      .sheet(item: $editingEvent) { event in
        EventFormView(isEditMode: true, existingEvent: event) {
          viewModel.fetchEvents()
        }
      }
      .sheet(isPresented: $isShowingEventFormView) {
        EventFormView(isEditMode: false) {
          viewModel.fetchEvents()
        }
      }
      .onAppear {
        viewModel.fetchEvents()
      }
    }
  }

  private func eventsList() -> some View {
    List {
      ForEach(viewModel.events) { event in
        NavigationLink(destination: EventView(event: event)) {
          EventRow(
            event: event,
            isOrganizer: userIsEventOrganizer(event),
            onEdit: { editEvent(event) }
          )
        }
      }
    }
    .refreshable {
      await refreshEvents()
    }
  }

  private func noEventsView() -> some View {
    VStack {
      Image(systemName: "calendar.badge.plus")
        .font(.system(size: 72))
        .foregroundColor(.blue.opacity(0.5))
        .padding(.bottom, 16)

      Text("No Events Yet")
        .font(.title2)
        .fontWeight(.bold)
      if appController.isOrganizer() {
        Text("Tap the + button to create your first event")
          .foregroundColor(.secondary)
          .multilineTextAlignment(.center)
          .padding(.horizontal, 32)
          .padding(.top, 8)

        Button {
          isShowingEventFormView = true
        } label: {
          Text("Create Event")
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(.blue)
            .cornerRadius(10)
        }
        .padding(.top, 24)
      }
    }
  }

  private struct EventRow: View {
    let event: Event
    let isOrganizer: Bool
    let onEdit: () -> Void

    var body: some View {
      VStack(alignment: .leading, spacing: 8) {
        HStack {
          Text(event.name)
            .font(.headline)

          if isOrganizer {
            Text("Your Event")
              .font(.caption)
              .fontWeight(.medium)
              .foregroundStyle(.white)
              .padding(.horizontal, 8)
              .padding(.vertical, 2)
              .background(Color.orange)
              .cornerRadius(8)
          }
          Spacer()
        }

        Text(formatDate(event.startDate, event.endDate))
          .font(.subheadline)
          .foregroundColor(.secondary)

        Text(event.venue)
          .font(.subheadline)
          .foregroundColor(.secondary)
      }
      .swipeActions(edge: .leading) {
        if isOrganizer {
          Button(action: onEdit) {
            Label("Edit", systemImage: "pencil")
          }
          .tint(.orange)
        }
      }
      .padding(.vertical, 4)
    }

    private func formatDate(_ start: TimeInterval, _ end: TimeInterval) -> String {
      let startDate = Date(timeIntervalSince1970: start)
      let endDate = Date(timeIntervalSince1970: end)

      let dateFormatter = DateFormatter()
      dateFormatter.dateStyle = .medium

      let timeFormatter = DateFormatter()
      timeFormatter.timeStyle = .short

      if Calendar.current.isDate(startDate, inSameDayAs: endDate) {
        return "\(dateFormatter.string(from: startDate)), \(timeFormatter.string(from: startDate)) - \(timeFormatter.string(from: endDate))"
      } else {
        return "\(dateFormatter.string(from: startDate)) - \(dateFormatter.string(from: endDate))"
      }
    }
  }

  private func refreshEvents() async {
    await withCheckedContinuation { continuation in
      viewModel.fetchEvents()
      continuation.resume()
    }
  }

  private func userIsEventOrganizer(_ event: Event) -> Bool {
    guard let user = appController.user, appController.isOrganizer() else { return false }
    return event.organizerId == user.id
  }

  private func editEvent(_ event: Event) {
    editingEvent = event
  }
}

#Preview {
  EventsView().withPreviewEnvironment()
}
