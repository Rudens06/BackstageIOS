//
//  EventsListView.swift
//  BackstageIOS
//
//  Created by Reinis Rudens on 15/05/2025.
//

import SwiftUI

struct EventsView: View {
  @State private var viewModel = EventsViewVM()
  @State private var isShowingNewEventView = false

  var body: some View {
    NavigationStack {
      ZStack {
        if viewModel.events.isEmpty {
          VStack {
            Image(systemName: "calendar.badge.plus")
              .font(.system(size: 72))
              .foregroundColor(.blue.opacity(0.5))
              .padding(.bottom, 16)

            Text("No Events Yet")
              .font(.title2)
              .fontWeight(.bold)

            Text("Tap the + button to create your first event")
              .foregroundColor(.secondary)
              .multilineTextAlignment(.center)
              .padding(.horizontal, 32)
              .padding(.top, 8)

            Button {
              isShowingNewEventView = true
            } label: {
              Text("Create Event")
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(Color.blue)
                .cornerRadius(10)
            }
            .padding(.top, 24)
          }
        } else {
          eventsList
        }
      }
      .navigationTitle("Events")
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button {
            isShowingNewEventView = true
          } label: {
            Image(systemName: "plus")
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
      .sheet(isPresented: $isShowingNewEventView) {
        NewEventView(onEventCreated: {
          viewModel.fetchEvents()
        })
      }
      .onAppear {
        viewModel.fetchEvents()
      }
    }
  }

  private var eventsList: some View {
    List {
      ForEach(viewModel.events) { event in
        EventRow(event: event)
      }
    }
    .refreshable {
      await refreshEvents()
    }
  }

  private struct EventRow: View {
    let event: Event

    var body: some View {
      VStack(alignment: .leading, spacing: 8) {
        Text(event.name)
          .font(.headline)

        Text(formatDate(event.startDate, event.endDate))
          .font(.subheadline)
          .foregroundColor(.secondary)

        Text(event.venue)
          .font(.subheadline)
          .foregroundColor(.secondary)
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
}

#Preview {
  EventsView()
}
