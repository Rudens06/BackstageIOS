//
//  PerformerView.swift
//  BackstageIOS
//
//  Created by Reinis Rudens on 17/05/2025.
//

import SwiftUI

struct PerformerView: View {
  @State private var viewModel: PerformerViewVM!

  init(performer: PerformerProfile) {
    self._viewModel = State(initialValue: PerformerViewVM(performer: performer))
  }

  var body: some View {
    if viewModel == nil {
      ProgressView()
    } else {
      VStack(alignment: .leading, spacing: 0) {
        ZStack(alignment: .bottomLeading) {
          Color.black
            .frame(height: 180)

          VStack(alignment: .leading, spacing: 4) {
            Text(viewModel.performer.name)
              .font(.system(size: 28, weight: .bold))
              .foregroundColor(.white)
              .padding(.horizontal)
              .padding(.bottom, 16)
          }
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding(.bottom, 20)
        }
        ScrollView {
          cardView()
          VStack {
            Text("Created: \(viewModel.formattedCreatedDate)")
              .font(.caption)
              .foregroundColor(.secondary)

            if viewModel.performer.updatedAt > viewModel.performer.createdAt + 60 {
              Text("Updated: \(viewModel.formattedUpdatedDate)")
                .font(.caption)
                .foregroundColor(.secondary)
            }
          }
          .frame(maxWidth: .infinity, alignment: .center)
          .padding(.vertical, 16)
        }
      }
      .edgesIgnoringSafeArea(.top)
    }
  }

  private func cardView() -> some View {
    VStack(spacing: 8) {
      if let url = viewModel.performer.imageUrl {
        performerImage(url: url)
      }

      InfoCard(icon: "text.alignleft", title: "Description") {
        Text(viewModel.performer.description)
      }

      InfoCard(icon: "person.2.fill", title: "Members") {
        Text("\(viewModel.performer.memberCount) member\(viewModel.performer.memberCount > 1 ? "s" : "")")
      }

      InfoCard(icon: "music.note.list", title: "Genres") {
        if !viewModel.performer.genres.isEmpty {
          HStack(spacing: 4) {
            ForEach(viewModel.performer.genres, id: \.self) { genre in
              Bubble(text: genre)
            }
          }
        } else {
          Text("No genres specified")
        }
      }

      if viewModel.performer.contactEmail != nil || viewModel.performer.contactPhone != nil {
        InfoCard(icon: "person.crop.circle.badge.questionmark", title: "Contact") {
          VStack(alignment: .leading, spacing: 8) {
            if let email = viewModel.performer.contactEmail {
              HStack(spacing: 8) {
                Image(systemName: "envelope.fill")
                  .foregroundColor(.orange)
                  .font(.system(size: 18))
                  .frame(width: 24)
                Text(email)
              }
            }
            if let phone = viewModel.performer.contactPhone {
              HStack(spacing: 8) {
                Image(systemName: "phone.fill")
                  .foregroundColor(.orange)
                  .font(.system(size: 18))
                  .frame(width: 24)
                Text(phone)
              }
            }
          }
        }
      }
    }
    .padding(.top, 8)
  }

  private func performerImage(url: String) -> some View {
    AsyncImage(url: URL(string: url)) { image in
      image
        .resizable()
        .aspectRatio(contentMode: .fill)
        .frame(height: 250)
        .clipped()
        .clipShape(RoundedRectangle(cornerRadius: 12))
    } placeholder: {
      Image(systemName: "photo.fill")
        .font(.system(size: 50))
        .foregroundColor(.gray)
        .frame(height: 250)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    .frame(maxWidth: .infinity)
    .padding(.horizontal, 7)
  }
}

#Preview {
  PerformerView(performer: PerformerProfile.previewProfile)
}
