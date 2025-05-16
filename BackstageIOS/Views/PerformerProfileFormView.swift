//
//  PerformerProfileFormView.swift
//  BackstageIOS
//
//  Created by Reinis Rudens on 17/05/2025.
//

import SwiftUI

struct PerformerProfileFormView: View {
    @Environment(AppController.self) private var appController

    var isEditMode: Bool
    var existingProfile: PerformerProfile?

    @State private var viewModel: PerformerProfileFormViewVM!
    @Environment(\.dismiss) private var dismiss
    @State private var hasErrors = false
    @State private var newGenre = ""

    var onProfileSaved: (() -> Void)?

    var body: some View {
        NavigationStack {
            VStack {
                if viewModel == nil {
                    ProgressView()
                } else {
                    profileForm()
                }
            }
            .navigationTitle(isEditMode ? "Edit Performer Profile" : "Create Performer Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                if isEditMode, let profile = existingProfile {
                    viewModel = PerformerProfileFormViewVM(appController: appController, profile: profile)
                } else {
                    viewModel = PerformerProfileFormViewVM(appController: appController)
                }
            }
        }
    }

    func profileForm() -> some View {
        Form {
            Section("Performer Name") {
                TextField("Performer/Band Name", text: Bindable(viewModel).name)
            }

            Section("Description") {
                TextEditor(text: Bindable(viewModel).description)
                    .frame(height: 100)
            }

            Section("Band Members") {
                Stepper("Number of members: \(viewModel.memberCount)", value: Bindable(viewModel).memberCount, in: 1...100)
            }

            genresSection()

            Section("Contact Information") {
                TextField("Email", text: Bindable(viewModel).contactEmail)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)

                TextField("Phone Number", text: Bindable(viewModel).contactPhone)
                    .keyboardType(.phonePad)
            }

            Section {
                Button {
                    isEditMode ? viewModel.updateProfile() : viewModel.createProfile()
                    dismiss()
                    onProfileSaved?()
                } label: {
                    HStack {
                        Spacer()
                        Text("Save Profile")
                        Spacer()
                    }
                }
                .padding()
                .buttonStyle(.borderedProminent)
            }
        }
    }

    func genresSection() -> some View {
        Section(header: Text("Genres")) {
            ForEach(viewModel.genres, id: \.self) { genre in
                HStack {
                    Text(genre)
                    Spacer()
                    Button {
                        removeGenre(genre: genre)
                    } label: {
                        Image(systemName: "minus.circle.fill")
                            .foregroundStyle(.red)
                    }
                }
            }
            .onDelete(perform: removeGenres)

            HStack {
                TextField("New Genre", text: $newGenre)
                Button(action: addGenre) {
                    Image(systemName: "plus.circle.fill")
                }
                .disabled(newGenre.isEmpty)
            }
        }
    }

    func addGenre() {
        withAnimation(.easeInOut) {
            viewModel.genres.append(newGenre)
            newGenre = ""
        }
    }

    func removeGenre(genre: String) {
        if let index = viewModel.genres.firstIndex(of: genre) {
            _ = withAnimation(.easeInOut) {
                viewModel.genres.remove(at: index)
            }
        }
    }

    func removeGenres(offsets: IndexSet) {
        viewModel.genres.remove(atOffsets: offsets)
    }
}

#Preview {
  PerformerProfileFormView(isEditMode: false)
}
