//
//  ViewExtension.swift
//  BackstageIOS
//
//  Created by Reinis Rudens on 16/05/2025.
//

import Foundation
import SwiftUI

extension View {
  func withAppTheme() -> some View {
    self.modifier(AppThemeModifier())
  }

  func withPreviewEnvironment() -> some View {
    let appController = AppController()
    appController.user = User.previewUser

    return self.environment(appController)
  }
}

struct AppThemeModifier: ViewModifier {
  func body(content: Content) -> some View {
    content
      .background(Color(.systemGroupedBackground))
  }
}
