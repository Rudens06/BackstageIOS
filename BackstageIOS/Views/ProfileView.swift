import SwiftUI

struct ProfileView: View {
  @Environment(AppController.self) private var appControler
  @State private var isShowingNewPerformerForm = false
  @State private var editingPerformerProfile: PerformerProfile?

  var body: some View {
    Group {
      if let user = appControler.user {
        ScrollView {
          VStack(spacing: 24) {
            ProfileHeaderView(user: user)

            UserInfoCardsView(user: user)

            ActionButtonsView(
              showingForm: $isShowingNewPerformerForm,
              editingPerformerProfile: $editingPerformerProfile,
              isPerformer: appControler.isPerformer(),
              signOutAction: signOut
            ).environment(appControler)

            Spacer()
          }
          .padding()
        }
      } else {
        LoadingView()
      }
    }
    .sheet(item: $editingPerformerProfile) { performerProfile in
      PerformerProfileFormView(
        isEditMode: true,
        existingProfile: performerProfile
      )
    }
    .sheet(isPresented: $isShowingNewPerformerForm) {
      if appControler.isPerformer() {
        PerformerProfileFormView(isEditMode: false)
      }
    }
    .withAppTheme()
  }

  private func signOut() {
    do {
      try appControler.signOut()
    } catch {
      print("Error signing out: \(error.localizedDescription)")
    }
  }
}

struct ProfileHeaderView: View {
  let user: User

  var body: some View {
    VStack(spacing: 16) {
      ZStack {
        Circle()
          .fill(Color.white)
          .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 4)
          .frame(width: 120, height: 120)

        Text(String(user.name.prefix(1)))
          .font(.system(size: 42, weight: .bold))
          .foregroundColor(userRoleColor(for: user.userType))
      }

      VStack(spacing: 4) {
        Text(user.name)
          .font(.title)
          .fontWeight(.bold)

        HStack {
          Image(systemName: userRoleIcon(for: user.userType))
          Text(user.userType.rawValue.capitalized)
        }
        .font(.headline)
        .foregroundColor(userRoleColor(for: user.userType))
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(
          Capsule()
            .fill(userRoleColor(for: user.userType).opacity(0.15))
        )
      }
    }
    .frame(maxWidth: .infinity)
    .padding(.vertical, 24)
    .background(
      RoundedRectangle(cornerRadius: 16)
        .fill(Color(.systemBackground))
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    )
  }

  private func userRoleIcon(for userType: User.UserType) -> String {
    switch userType {
    case .organizer:
      return "calendar.badge.clock"
    case .technician:
      return "wrench.and.screwdriver.fill"
    case .performer:
      return "music.mic"
    }
  }

  private func userRoleColor(for userType: User.UserType) -> Color {
    switch userType {
    case .organizer:
      return Color.blue
    case .technician:
      return Color.orange
    case .performer:
      return Color.purple
    }
  }
}

struct UserInfoCardsView: View {
  let user: User

  var body: some View {
    VStack(spacing: 16) {
      ProfileInfoCard(icon: "envelope.fill", title: "Email", value: user.email)

      ProfileInfoCard(icon: "calendar", title: "Member Since", value: formatDate(from: user.joined))
    }
  }

  private func formatDate(from timeInterval: TimeInterval) -> String {
    let date = Date(timeIntervalSince1970: timeInterval)
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter.string(from: date)
  }
}

struct ProfileInfoCard: View {
  let icon: String
  let title: String
  let value: String

  var body: some View {
    HStack {
      Image(systemName: icon)
        .font(.system(size: 20))
        .foregroundColor(.gray)
        .frame(width: 32)

      VStack(alignment: .leading, spacing: 4) {
        Text(title)
          .font(.caption)
          .foregroundColor(.secondary)

        Text(value)
          .font(.body)
      }

      Spacer()
    }
    .padding()
    .background(
      RoundedRectangle(cornerRadius: 12)
        .fill(Color(.systemBackground))
        .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 1)
    )
  }
}

struct ActionButtonsView: View {
  @Environment(AppController.self) private var appController
  @Binding var showingForm: Bool
  @Binding var editingPerformerProfile: PerformerProfile?
  let isPerformer: Bool
  let signOutAction: () -> Void

  var body: some View {
    VStack(spacing: 12) {

      if isPerformer {
        if let performerProfile = appController.performerProfile {
          Button(action: {
            editingPerformerProfile = performerProfile
          }) {
            HStack {
              Image(systemName: "music.mic")
              Text("Edit Performer Profile")
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(
              RoundedRectangle(cornerRadius: 12)
                .fill(.orange)
            )
            .foregroundColor(.white)
          }
        } else {
          Button(action: {
            showingForm = true
          }) {
            HStack {
              Image(systemName: "music.mic")
              Text("Create Performer Profile")
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(
              RoundedRectangle(cornerRadius: 12)
                .fill(.orange)
            )
            .foregroundColor(.white)
          }
        }
      }

      Divider()
        .padding(.vertical, 8)

      Button(action: signOutAction) {
        HStack {
          Image(systemName: "rectangle.portrait.and.arrow.right")
          Text("Sign Out")
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
          RoundedRectangle(cornerRadius: 12)
            .fill(Color.red.opacity(0.1))
        )
        .foregroundColor(.red)
      }
    }
  }
}

struct LoadingView: View {
  var body: some View {
    VStack {
      ProgressView()
        .scaleEffect(1.5)
        .padding()

      Text("Loading user profile...")
        .font(.headline)
        .foregroundColor(.secondary)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color(.systemGroupedBackground))
    .edgesIgnoringSafeArea(.all)
  }
}

#Preview {
  ProfileView()
}
