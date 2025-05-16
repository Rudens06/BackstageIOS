//
//  OrganizerDashboard.swift
//  BackstageIOS
//
//  Created by Reinis Rudens on 16/05/2025.
//

import SwiftUI

struct PerformerDashboardView: View {
  @Environment(AppController.self) private var appController

  var body: some View {
    if let user = appController.user {
      SharedDashboardView(user: user)
    }
  }
}

#Preview {
  PerformerDashboardView().withPreviewEnvironment()
}
