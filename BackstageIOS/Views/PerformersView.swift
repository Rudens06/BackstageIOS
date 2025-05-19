//
//  PerformersView.swift
//  BackstageIOS
//
//  Created by Reinis Rudens on 17/05/2025.
//

import SwiftUI

struct PerformersView: View {
  @Environment(AppController.self) private var appController
  @State private var viewModel = PerformersViewVM()

  var body: some View {
    NavigationStack {
      ZStack {
        if viewModel.performers.isEmpty {
          noPerformersView()
        } else {
          performersList()
        }
      }
      .navigationTitle("Performers")
    }
    .onAppear {
      viewModel.fetchPerformers()
    }
  }

  private func performersList() -> some View {
    List {
      ForEach(viewModel.performers) { performer in
        NavigationLink(destination: PerformerView(performer: performer)) {
          PerformerRow(
            performer: performer
          )
        }
      }
    }
    .refreshable {
      await refreshPerformers()
    }
  }

  private func refreshPerformers() async {
    await withCheckedContinuation { continuation in
      viewModel.fetchPerformers()
      continuation.resume()
    }
  }
}

private struct PerformerRow: View {
  let performer: PerformerProfile

  var body: some View {
    VStack(alignment: .leading, spacing: 8) {

      Text(performer.name)
        .font(.headline)

      HStack(spacing: 4){
        ForEach(performer.genres, id: \.self) { genre in
          Bubble(text: genre)
        }
      }

      HStack(spacing: 4) {
        Text("Member Count:")
        Text(String(performer.memberCount))
          .font(.subheadline)
          .foregroundColor(.secondary)
      }
    }
    .padding(.vertical, 4)
  }
}

private func noPerformersView() -> some View {
  VStack {
    Image(systemName: "music.mic")
      .font(.system(size: 72))
      .foregroundColor(.orange.opacity(0.5))
      .padding(.bottom, 16)

    Text("No Performers Yet")
      .font(.title2)
      .fontWeight(.bold)
  }
}

#Preview {
  PerformersView().withPreviewEnvironment()
}
