import SwiftUI
import CoreData

struct CreateTaskView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) private var viewContext

    var existingTask: Task?
    @Binding var needsRefresh: Bool

    @State private var title: String
    @State private var description: String
    @State private var dueDate: Date
    @State private var priority: String

    let priorities = ["Low", "Medium", "High"]

    init(task: Task? = nil, needsRefresh: Binding<Bool>) {
        self.existingTask = task
        self._needsRefresh = needsRefresh
        _title = State(initialValue: task?.title ?? "")
        _description = State(initialValue: task?.taskDescription ?? "")
        _dueDate = State(initialValue: task?.dueDate ?? Date())
        _priority = State(initialValue: task?.priority ?? "Medium")
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {

                    // Page Title
                    Text(existingTask == nil ? "Create Task" : "Edit Task")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top, 20)

                    // Input Fields
                    TaskInputField(title: "Task Title", text: $title)
                    TaskInputField(title: "Description", text: $description)

                    // Due Date Picker
                    DueDatePicker(dueDate: $dueDate)

                    // Priority Selector
                    PrioritySelector(priority: $priority, priorities: priorities)

                    Spacer()

                    // Save & Cancel Buttons
                    HStack {
                        CancelButton(action: { dismiss() })
                        SaveButton(action: saveTask)
                    }
                }
                .padding(.horizontal)
            }
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.black, Color(red: 18/255, green: 18/255, blue: 18/255)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
            )
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

        taskToSave.title = title
        taskToSave.taskDescription = description
        taskToSave.dueDate = dueDate
        taskToSave.priority = priority

        do {
            try viewContext.save()
            needsRefresh.toggle()
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

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .foregroundColor(Color(UIColor.systemGray2))
            TextField("Enter \(title.lowercased())", text: $text)
                .padding()
                .background(Color(UIColor.systemGray5))
                .cornerRadius(10)
                .foregroundColor(.white)
        }
    }
}

struct DueDatePicker: View {
    @Binding var dueDate: Date

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
                    .foregroundColor(.white)
                Spacer()
            }
        }
    }
}

struct PrioritySelector: View {
    @Binding var priority: String
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
                            .foregroundColor(.white)
                            .opacity(priority == priorityOption ? 1.0 : 0.6)
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
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text("Cancel")
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(UIColor.systemGray4))
                .foregroundColor(.white)
                .cornerRadius(10)
        }
    }
}

struct SaveButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text("Save Task")
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
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
