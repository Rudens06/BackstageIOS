//
//  EventView.swift
//  BackstageIOS
//
//  Created by Reinis Rudens on 15/05/2025.
//

import SwiftUI

struct EventView: View {
  @State private var viewModel: EventViewVM!
  
  init(event: Event) {
    self._viewModel = State(initialValue: EventViewVM(event: event))
  }
  
  var body: some View {
    if viewModel == nil {
      ProgressView()
    } else {
      VStack(alignment: .leading, spacing: 0) {
        ZStack(alignment: .bottomLeading) {
          Color.black
            .frame(height: 180)
          
          VStack(alignment: .leading, spacing: 4) {
            Text(viewModel.event.name)
              .font(.system(size: 28, weight: .bold))
              .foregroundColor(.white)
              .padding(.horizontal)
              .padding(.bottom, 16)
          }
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding(.bottom, 20)
        }
        ScrollView {
          VStack(spacing: 8) {
            if let url = viewModel.event.imageUrl {
              eventImage(url: url)
            }

            InfoCard(icon: "calendar", title: "Date & Time") {
              VStack(alignment: .leading, spacing: 4) {
                Text(viewModel.dateOnly)
                  .font(.system(size: 16))
                  .foregroundColor(.primary)
                
                Text(viewModel.timeRange)
                  .font(.system(size: 16))
                  .foregroundColor(.primary)
              }
            }
            
            InfoCard(icon: "mappin.circle", title: "Location") {
              Text(viewModel.event.venue)
            }
            
            InfoCard(icon: "text.alignleft", title: "Description") {
              Text(viewModel.event.description)
            }
            
            InfoCard(icon: "person.fill", title: "Organizer") {
              Text(viewModel.event.organizerName)
            }
            
            InfoCard(icon: "music.mic", title: "Performers") {

              if !viewModel.event.performers.isEmpty {
                ForEach(viewModel.event.performers, id: \.self) { performer in
                  Text(performer)
                }
              } else {
                Text("No performers added yet!")
              }
              
            }
          }
          .padding(.top, 8)
          
          VStack {
            Text("Created: \(viewModel.formattedCreatedDate)")
              .font(.caption)
              .foregroundColor(.secondary)
            
            if viewModel.event.updatedAt > viewModel.event.createdAt + 60 {
              Text("Updated: \(viewModel.formattedUpdatedDate)")
                .font(.caption)
                .foregroundColor(.secondary)
            }
          }
          .frame(maxWidth: .infinity, alignment: .center)
          .padding(.vertical, 16)
        }
      }
      .edgesIgnoringSafeArea(.top)
    }
  }

  private func eventImage(url: String) -> some View {
    AsyncImage(url: URL(string: url)) { image in
      image
        .resizable()
        .aspectRatio(contentMode: .fill)
        .frame(height: 250)
        .clipped()
        .clipShape(RoundedRectangle(cornerRadius: 12))
    } placeholder: {
      Image(systemName: "photo.fill")
        .font(.system(size: 50))
        .foregroundColor(.gray)
        .frame(height: 250)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    .frame(maxWidth: .infinity)
    .padding(.horizontal, 7)
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
    performers: ["Tante Gaida", "Nova Koma", "Krāsa"],
    createdAt: Date().timeIntervalSince1970,
    updatedAt: Date().timeIntervalSince1970))
}
