//
//  PerformerViewVM.swift
//  BackstageIOS
//
//  Created by Reinis Rudens on 17/05/2025.
//

import Foundation

@Observable
class PerformerViewVM {
  let performer: PerformerProfile

  init(performer: PerformerProfile) {
    self.performer = performer
  }

  var formattedCreatedDate: String {
    dateFormatter.string(from: Date(timeIntervalSince1970: performer.createdAt))
  }

  var formattedUpdatedDate: String {
    dateFormatter.string(from: Date(timeIntervalSince1970: performer.updatedAt))
  }

  private var dateFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    return formatter
  }
}
