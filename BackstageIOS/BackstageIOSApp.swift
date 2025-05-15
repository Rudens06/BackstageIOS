//
//  BackstageIOSApp.swift
//  BackstageIOS
//
//  Created by Reinis Rudens on 15/05/2025.
//

import SwiftUI

@main
struct BackstageIOSApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

  @State private var appControler = AppController()

  var body: some Scene {
    WindowGroup {
      ContentView()
        .environment(appControler)
        .onAppear {
          appControler.listenToAuthChanges()
        }
    }
  }
}
