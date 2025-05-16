//
//  EventViewVM.swift
//  BackstageIOS
//
//  Created by Reinis Rudens on 15/05/2025.
//

import Foundation

@Observable
class EventViewVM {
  let event: Event
  
  init(event: Event) {
    self.event = event
  }
  
  var dateOnly: String {
    let date = Date(timeIntervalSince1970: event.startDate)
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .none
    return formatter.string(from: date)
  }
  
  var timeRange: String {
    let startDate = Date(timeIntervalSince1970: event.startDate)
    let endDate = Date(timeIntervalSince1970: event.endDate)
    
    let formatter = DateFormatter()
    formatter.dateStyle = .none
    formatter.timeStyle = .short
    
    return "\(formatter.string(from: startDate)) - \(formatter.string(from: endDate))"
  }
  
  var formattedCreatedDate: String {
    dateFormatter.string(from: Date(timeIntervalSince1970: event.createdAt))
  }
  
  var formattedUpdatedDate: String {
    dateFormatter.string(from: Date(timeIntervalSince1970: event.updatedAt))
  }
  
  // Helper for organizer avatar
  var organizerInitials: String {
    let words = event.organizerName.components(separatedBy: " ")
    let initials = words.prefix(2).compactMap { $0.first }
    return String(initials.prefix(2))
  }
  
  // Date formatter for metadata
  private var dateFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    return formatter
  }
}
