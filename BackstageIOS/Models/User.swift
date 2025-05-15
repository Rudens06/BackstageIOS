//
//  User.swift
//  BackstageIOS
//
//  Created by Reinis Rudens on 15/05/2025.
//

import Foundation

struct User: Codable, Identifiable {
  let id: String
  let name: String
  let email: String
  let joined: TimeInterval
  let userType: UserType

  enum UserType: String, Codable {
    case organizer
    case technician
    case performer
  }
}
