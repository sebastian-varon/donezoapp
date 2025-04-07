import SwiftUI
import CoreData

struct CreateTaskView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.colorScheme) var colorScheme

    var existingTask: Task?
    @Binding var needsRefresh: Bool

    // Read the global toggle from AppStorage
    @AppStorage("notificationsEnabled") private var notificationsEnabled = true

    // Existing fields
    @State private var title: String
    @State private var description: String
    @State private var dueDate: Date
    @State private var priority: String

    // New fields for reminder
    @State private var hasReminder: Bool
    @State private var reminderDate: Date

    let priorities = ["Low", "Medium", "High"]

    init(task: Task? = nil, needsRefresh: Binding<Bool>) {
        self.existingTask = task
        self._needsRefresh = needsRefresh
        _title = State(initialValue: task?.title ?? "")
        _description = State(initialValue: task?.taskDescription ?? "")
        _dueDate = State(initialValue: task?.dueDate ?? Date())
        _priority = State(initialValue: task?.priority ?? "Medium")

        // Load from the existing task if editing; else defaults
        _hasReminder = State(initialValue: task?.hasReminder ?? false)
        _reminderDate = State(initialValue: task?.reminderDate ?? Date())
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Page Title
                    Text(existingTask == nil ? "Create Task" : "Edit Task")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color.primaryText(for: colorScheme))
                        .padding(.top, 20)

                    // Input Fields
                    TaskInputField(title: "Task Title", text: $title)
                    TaskInputField(title: "Description", text: $description)

                    // Due Date Picker
                    DueDatePicker(dueDate: $dueDate)

                    // Priority Selector
                    PrioritySelector(priority: $priority, priorities: priorities)

                    // Reminder Toggle
                    Toggle("Set a Reminder?", isOn: $hasReminder)
                        .foregroundColor(Color.primaryText(for: colorScheme))

                    // Show a DatePicker only if user wants a reminder
                    if hasReminder {
                        DatePicker("Reminder Date & Time",
                                   selection: $reminderDate,
                                   displayedComponents: [.date, .hourAndMinute])
                            .datePickerStyle(.compact)
                            .padding()
                            .background(Color(UIColor.systemGray5))
                            .cornerRadius(10)
                            .foregroundColor(Color.primaryText(for: colorScheme))
                    }

                    Spacer()

                    // Save & Cancel Buttons
                    HStack {
                        CancelButton(action: { dismiss() })
                        SaveButton(action: saveTask)
                    }
                }
                .padding(.horizontal)
            }
<<<<<<< HEAD
            .background(Color.background(for: colorScheme))
=======
            Color.background(for: colorScheme)
                .ignoresSafeArea()
>>>>>>> 511acb557681dd40e831db4746471ebb931aa903
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func saveTask() {
        guard !title.isEmpty else {
            print("❌ Title is required.")
            return
        }

        let taskToSave = existingTask ?? Task(context: viewContext)

        if existingTask == nil {
            taskToSave.id = UUID()
            taskToSave.isCompleted = false
        }

        // Standard fields
        taskToSave.title = title
        taskToSave.taskDescription = description
        taskToSave.dueDate = dueDate
        taskToSave.priority = priority

        // New fields for reminders (assuming your Task entity has them)
        taskToSave.hasReminder = hasReminder
        taskToSave.reminderDate = hasReminder ? reminderDate : nil

        do {
            // Save the context
            try viewContext.save()
            needsRefresh.toggle()

            // Now schedule or cancel notifications
            let notificationID = taskToSave.id?.uuidString ?? ""

            if hasReminder, let date = taskToSave.reminderDate, notificationsEnabled {
                // Cancel any old one first (avoid duplicates)
                NotificationManager.shared.cancelNotification(id: notificationID)
                // Then schedule a new one
                NotificationManager.shared.scheduleNotification(
                    id: notificationID,
                    title: "Task Reminder",
                    body: "“\(title)” is coming up!",
                    date: date
                )
            } else {
                // Otherwise, cancel any existing notification
                NotificationManager.shared.cancelNotification(id: notificationID)
            }

            dismiss()
        } catch {
            print("❌ Error saving task: \(error.localizedDescription)")
        }
    }
}

// MARK: - Subviews

struct TaskInputField: View {
    let title: String
    @Binding var text: String
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .foregroundColor(Color(UIColor.systemGray2))
            TextField("Enter \(title.lowercased())", text: $text)
                .padding()
                .background(Color(UIColor.systemGray5))
                .cornerRadius(10)
                .foregroundColor(Color.primaryText(for: colorScheme))
        }
    }
}

struct DueDatePicker: View {
    @Binding var dueDate: Date
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack(alignment: .leading) {
            Text("Due Date")
                .foregroundColor(Color(UIColor.systemGray2))
            HStack {
                DatePicker("", selection: $dueDate, displayedComponents: .date)
                    .datePickerStyle(CompactDatePickerStyle())
                    .labelsHidden()
                    .padding()
                    .background(Color(UIColor.systemGray5))
                    .cornerRadius(10)
                    .foregroundColor(Color.primaryText(for: colorScheme))
                Spacer()
            }
        }
    }
}

struct PrioritySelector: View {
    @Binding var priority: String
    @Environment(\.colorScheme) var colorScheme
    let priorities: [String]

    var body: some View {
        VStack(alignment: .leading) {
            Text("Priority")
                .foregroundColor(Color(UIColor.systemGray2))
            HStack {
                ForEach(priorities, id: \.self) { priorityOption in
                    Button(action: {
                        self.priority = priorityOption
                    }) {
                        Text(priorityOption)
                            .fontWeight(.thin)
                            .foregroundColor(Color.primaryText(for: colorScheme))
                            .opacity(priority == priorityOption ? 1.0 : 0.1)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                            .background(priorityColor(priorityOption))
                            .cornerRadius(20)
                    }
                }
            }
        }
    }
}

struct CancelButton: View {
    @Environment(\.colorScheme) var colorScheme
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text("Cancel")
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(UIColor.systemGray4))
                .foregroundColor(Color.primaryText(for: colorScheme))
                .cornerRadius(10)
        }
    }
}

struct SaveButton: View {
    @Environment(\.colorScheme) var colorScheme
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text("Save Task")
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(Color.primaryText(for: colorScheme))
                .cornerRadius(10)
        }
    }
}

func priorityColor(_ priority: String) -> Color {
    switch priority {
    case "High": return Color.red.opacity(0.3)
    case "Medium": return Color.yellow.opacity(0.3)
    case "Low": return Color.green.opacity(0.3)
    default: return Color.gray.opacity(0.3)
    }
}
