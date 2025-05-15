//
//  NewEventView.swift
//  BackstageIOS
//
//  Created by Reinis Rudens on 15/05/2025.
//

import SwiftUI

struct NewEventView: View {
  @Environment(AppController.self) private var appController

  @State private var viewModel: NewEventViewVM!
  @Environment(\.dismiss) private var dismiss
  @State private var showCreateEventSuccessAlert = false
  @State private var hasErrors = false

  var onEventCreated: (() -> Void)?

  var body: some View {
    VStack {
      if viewModel == nil {
        ProgressView()
      } else {
        Text("Create New Event")
          .font(.largeTitle)
          .padding()

        Form {
          Section("Event Name") {
            TextField("Event Name", text: Bindable(viewModel).eventName)
          }
          Section("Event Description") {
            TextEditor(text: Bindable(viewModel).eventDescription)
          }
          Section("Event Location") {
            TextField("Event Location", text: Bindable(viewModel).venue)
          }
          Section("Event Date") {
            DatePicker("Start Date", selection: Bindable(viewModel).startDate, displayedComponents: [.date, .hourAndMinute])
              .datePickerStyle(.compact)
            DatePicker("End Date", selection: Bindable(viewModel).endDate, displayedComponents: [.date, .hourAndMinute])
              .datePickerStyle(.compact)
            Button {
              viewModel.createEvent()
              dismiss()
              onEventCreated?()
            } label: {
              HStack {
                Spacer()
                Text("Create Event")
                Spacer()
              }
            }
            .padding()
            .buttonStyle(.borderedProminent)
          }
        }
      }
    }
    .onAppear {
      viewModel = NewEventViewVM(appController: appController)
    }
  }
}

#Preview {
  let appController = AppController()
  NewEventView().environment(appController)
}
