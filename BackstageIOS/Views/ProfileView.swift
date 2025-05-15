import SwiftUI

struct ProfileView: View {
  @Environment(AppController.self) private var appControler
  @State private var showingAlert = false
  @State private var alertMessage = ""

  var body: some View {
    Group {
      if let user = appControler.user {
        ScrollView {
          VStack(spacing: 24) {
            ProfileHeaderView(user: user)

            UserInfoCardsView(user: user)

            ActionButtonsView(signOutAction: signOut)

            Spacer()
          }
          .padding()
        }
        .background(Color(.systemGroupedBackground))
      } else {
        LoadingView()
      }
    }
    .alert("Notification", isPresented: $showingAlert) {
      Button("OK", role: .cancel) {}
    } message: {
      Text(alertMessage)
    }
  }
  
  private func signOut() {
    do {
      try appControler.signOut()
    } catch {
      alertMessage = "Error signing out: \(error.localizedDescription)"
      showingAlert = true
    }
  }
}

// MARK: - Profile Header View
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

// MARK: - User Info Cards View
struct UserInfoCardsView: View {
  let user: User

  var body: some View {
    VStack(spacing: 16) {
      InfoCard(icon: "envelope.fill", title: "Email", value: user.email)

      InfoCard(icon: "calendar", title: "Member Since", value: formatDate(from: user.joined))
    }
  }

  private func formatDate(from timeInterval: TimeInterval) -> String {
    let date = Date(timeIntervalSince1970: timeInterval)
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter.string(from: date)
  }
}

struct InfoCard: View {
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

// MARK: - Action Buttons View
struct ActionButtonsView: View {
  let signOutAction: () -> Void

  var body: some View {
    VStack(spacing: 12) {
      Button(action: {}) {
        HStack {
          Image(systemName: "gear")
          Text("Settings")
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
          RoundedRectangle(cornerRadius: 12)
            .fill(Color(.systemBackground))
        )
        .foregroundColor(.primary)
      }

      Button(action: {}) {
        HStack {
          Image(systemName: "bell")
          Text("Notifications")
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
          RoundedRectangle(cornerRadius: 12)
            .fill(Color(.systemBackground))
        )
        .foregroundColor(.primary)
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

// MARK: - Loading View
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
