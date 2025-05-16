//
//  UserExtension.swift
//  BackstageIOS
//
//  Created by Reinis Rudens on 16/05/2025.
//

import Foundation

extension User {
  static var previewUser: User {
    User(
      id: "123",
      name: "Reinis",
      email: "email@gmail.com",
      joined: Date().timeIntervalSinceReferenceDate,
      userType: .organizer
    )
  }
}
