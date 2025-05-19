//
//  Bubble.swift
//  BackstageIOS
//
//  Created by Reinis Rudens on 17/05/2025.
//

import SwiftUI

struct Bubble: View {
  let text: String

  var body: some View {
    Text(text)
      .font(.caption)
      .fontWeight(.medium)
      .foregroundStyle(.white)
      .padding(.horizontal, 12)
      .padding(.vertical, 2)
      .background(.orange)
      .cornerRadius(8)
  }
}

#Preview {
  Bubble(text: "Test Text")
}
