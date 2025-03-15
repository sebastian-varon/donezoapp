import SwiftUI

struct CreateTaskView: View {
    @Environment(\.dismiss) var dismiss

    @State private var title: String = ""
    @State private var description: String = ""
    @State private var dueDate = Date()
    @State private var priority: String = "Medium"

    let priorities = ["Low", "Medium", "High"]

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {

                    // Page Title
                    Text("Create Task")
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
                        SaveButton(action: { dismiss() }) // No Core Data, just UI
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
            Text("Save Task") // Just UI, no Core Data
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
