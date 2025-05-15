//
//  ContentView.swift
//  BackstageIOS
//
//  Created by Reinis Rudens on 15/05/2025.
//

import SwiftUI

struct ContentView: View {
  @Environment(AppController.self) private var appControler

  var body: some View {
    Group {
      switch appControler.authState {
        case .undefinded:
          ProgressView()
        case .unauthenticated:
          AuthView()
        case .authenticated:
          MainTabView()
      }
    }
  }
}

#Preview {
    ContentView()
}
