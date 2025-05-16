import SwiftUI

struct EventFormView: View {
  @Environment(AppController.self) private var appController

  var isEditMode: Bool
  var existingEvent: Event?

  @State private var viewModel: EventFormViewVM!
  @Environment(\.dismiss) private var dismiss
  @State private var hasErrors = false
  @State private var newPerformerName = ""

  var onEventSaved: (() -> Void)?

  var body: some View {
    NavigationStack {
      VStack {
        if viewModel == nil {
          ProgressView()
        } else {
          eventForm()
        }
      }
      .navigationTitle(isEditMode ? "Edit Event" : "Create New Event")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button("Cancel") {
            dismiss()
          }
        }
      }
      .onAppear {
        if isEditMode, let event = existingEvent {
          viewModel = EventFormViewVM(appController: appController, event: event)
        } else {
          viewModel = EventFormViewVM(appController: appController)
        }
      }
    }
  }

  func eventForm() -> some View {
    Form {
      Section("Event Name") {
        TextField("Event Name", text: Bindable(viewModel).name)
      }
      Section("Event Description") {
        TextEditor(text: Bindable(viewModel).description)
          .frame(height: 100)
      }
      Section("Event Location") {
        TextField("Event Location", text: Bindable(viewModel).venue)
      }
      performerSection()
      Section("Event Date") {
        DatePicker("Start Date", selection: Bindable(viewModel).startDate, displayedComponents: [.date, .hourAndMinute])
          .datePickerStyle(.compact)
        DatePicker("End Date", selection: Bindable(viewModel).endDate, displayedComponents: [.date, .hourAndMinute])
          .datePickerStyle(.compact)
        Button {
          isEditMode ? viewModel.updateEvent() : viewModel.createEvent()
          dismiss()
          onEventSaved?()
        } label: {
          HStack {
            Spacer()
            Text("Save Event")
            Spacer()
          }
        }
        .padding()
        .buttonStyle(.borderedProminent)
      }
    }
  }

  func performerSection() -> some View {
    List {
      Section("Performers") {
        ForEach(viewModel.performers, id: \.self) { performer in
          HStack {
            Text(performer)
            Spacer()
            Button {
              removePerformer(performer: performer)
            } label: {
              Image(systemName: "minus.circle.fill")
                .foregroundStyle(.red)
            }
          }
        }
        .onDelete(perform: removePerformers)

        HStack {
          TextField("New Performer", text: $newPerformerName)
          Button(action: addPerformer) {
            Image(systemName: "plus.circle.fill")
          }
          .disabled(newPerformerName.isEmpty)
        }
      }
    }
  }

  func addPerformer() {
    withAnimation {
      viewModel.performers.append(newPerformerName)
      newPerformerName = ""
    }
  }

  func removePerformer(performer: String) {
    if let index = viewModel.performers.firstIndex(of: performer) {
      _ = withAnimation(.easeInOut) {
        viewModel.performers.remove(at: index)
      }
    }
  }

  func removePerformers(offsets: IndexSet) {
    viewModel.performers.remove(atOffsets: offsets)
  }
}

#Preview {
  let appController = AppController()
  EventFormView(isEditMode: false).environment(appController)
}
