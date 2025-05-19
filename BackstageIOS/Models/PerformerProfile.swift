//
//  Performer.swift
//  BackstageIOS
//
//  Created by Reinis Rudens on 17/05/2025.
//

import Foundation

struct PerformerProfile: Identifiable, Hashable, Codable {
  var id: String
  var userId: String
  var name: String
  var description: String
  var memberCount: Int
  var genres: [String]
  var imageUrl: String?
  var contactEmail: String?
  var contactPhone: String?
  var createdAt: TimeInterval
  var updatedAt: TimeInterval
}
