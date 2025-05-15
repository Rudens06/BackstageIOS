//
//  Event.swift
//  BackstageIOS
//
//  Created by Reinis Rudens on 15/05/2025.
//

import Foundation

struct Event: Codable, Identifiable {
  var id: String
  var name: String
  var description: String
  var organizerId: User.ID
  var organizerName: String
  var startDate: TimeInterval
  var endDate: TimeInterval
  var venue: String
//  var performers: [PerformerInfo]
//  var techRequirements: TechRequirements
//  var status: EventStatus
//  var bids: [String]?
//  var acceptedBidId: String?
  var createdAt: TimeInterval
  var updatedAt: TimeInterval
}
