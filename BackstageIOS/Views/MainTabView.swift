//
//  MainTabView.swift
//  BackstageIOS
//
//  Created by Reinis Rudens on 15/05/2025.
//

import SwiftUI

struct MainTabView: View {
  @Environment(AppController.self) private var appControler

  var body: some View {
    TabView {
      switch appControler.user?.userType {
      case .performer:
        //        PerformerDashboardView()
        Text("Performer Dashboard")
          .tabItem {
            Label("Dashboard", systemImage: "music.note")
          }
        //        RiderView()
        Text("Rider View")
          .tabItem {
            Label("Rider", systemImage: "doc.text")
          }

      case .organizer:
        //        OrganizerDashboardView()
        Text("Organizer Dashboard")
          .tabItem {
            Label("Dashboard", systemImage: "calendar")
          }
        //        PerformerListView()
        Text("Performer List")
          .tabItem {
            Label("Performers", systemImage: "person.3")
          }

      case .technician:
        //        TechnicianDashboardView()
        Text("Technician Dashboard")
          .tabItem {
            Label("Dashboard", systemImage: "wrench.and.screwdriver")
          }

        //        PerformerListView()
        Text("Performer List")
          .tabItem {
            Label("Performers", systemImage: "person.3")
          }

      default:
        Text("Please log out and log back in")
      }

        EventsView()
        .tabItem {
          Label("Events", systemImage: "ticket")
        }

      ProfileView()
        .tabItem {
          Label("Profile", systemImage: "person")
        }
    }
    .onAppear() {
      appControler.fetchUser()
    }
  }
}

#Preview {
  MainTabView()
}
