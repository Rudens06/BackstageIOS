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
}
