//
//  InfoCard.swift
//  BackstageIOS
//
//  Created by Reinis Rudens on 17/05/2025.
//

import SwiftUI

struct InfoCard<Content: View>: View {
  let icon: String
  let title: String
  let content: Content

  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      HStack {
        Image(systemName: icon)
          .foregroundColor(.orange)
          .font(.system(size: 18))
          .frame(width: 24)

        Text(title)
          .font(.headline)
          .foregroundColor(.primary)
      }

      content
        .padding(.leading, 30)
    }
    .padding(16)
    .frame(maxWidth: .infinity, alignment: .leading)
    .background(Color(.systemGray6))
    .cornerRadius(12)
    .padding(.horizontal, 10)
  }

  init(icon: String, title: String, @ViewBuilder content: () -> Content) {
    self.icon = icon
    self.title = title
    self.content = content()
  }
}

#Preview {
  InfoCard(icon: "music.mic", title: "Test Title") {
    Text("Test Content")
  }
}
