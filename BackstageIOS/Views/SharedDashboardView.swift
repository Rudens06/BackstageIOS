//
//  SharedDashboardView.swift
//  BackstageIOS
//
//  Created by Reinis Rudens on 17/05/2025.
//

import SwiftUI

struct SharedDashboardView: View {
  let user: User

  var body: some View {
    NavigationStack {
      VStack(alignment: .leading, spacing: 20) {
        HStack {
          Text("Hello, \(user.name)!")
            .font(.title)
            .fontWeight(.semibold)
            .padding(.top, 20)
          Spacer()
        }
        Text("Wellcome to Backstage!")
          .font(.title3)
        Spacer()
      }
      .padding(.leading, 20)
      .navigationTitle("Dashboard")
      .withAppTheme()
    }
  }
}

#Preview {
  SharedDashboardView(user: User.previewUser)
}
