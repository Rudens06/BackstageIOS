//
//  BSTextField.swift
//  BackstageIOS
//
//  Created by Reinis Rudens on 15/05/2025.
//

import SwiftUI

struct BSTextField: View {
  @Binding var text: String
  var placeholder: String
  var image: String?
  var isSecure: Bool = false

  var body: some View {
    HStack {
      if let image = image {
        Image(systemName: image)
      }
      if isSecure {
        SecureField(placeholder, text: $text)
      } else {
        TextField(placeholder, text: $text)
      }
    }
    .padding(.vertical, 6)
    .background(Divider(), alignment: .bottom)
    .padding(.bottom, 8)
  }
}

#Preview {
    BSTextField(text: .constant(""), placeholder: "Placeholder", image: "lock", isSecure: true)
}
