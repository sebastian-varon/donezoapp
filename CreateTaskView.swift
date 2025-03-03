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
                    
                    // Due Date Picker (Fixed Alignment)
                    DueDatePicker(dueDate: $dueDate)
                    
                    // Priority Selector (Fixed Text Color)
                    PrioritySelector(priority: $priority, priorities: priorities)
                    
                    Spacer()
                    
                    // Save & Cancel Buttons
                    HStack {
                        CancelButton(action: { dismiss() })
                        SaveButton(action: {
                            print("Task Saved!")
                            dismiss()
                        })
                    }
                }
                .padding(.horizontal)
            }
            .background(
                LinearGradient(gradient: Gradient(colors: [Color.black, Color(red: 18/255, green: 18/255, blue: 18/255)]),
                               startPoint: .top,
                               endPoint: .bottom)
                .ignoresSafeArea()
            )
            .navigationBarTitleDisplayMode(.inline) // Keeps title clean
        }
    }
}

// MARK: - Subviews

/// **Reusable Text Input Field**
struct TaskInputField: View {
    let title: String
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .foregroundColor(.gray)
            TextField("Enter \(title.lowercased())", text: $text)
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(10)
                .foregroundColor(.white)
        }
    }
}

/// **Due Date Picker**
struct DueDatePicker: View {
    @Binding var dueDate: Date
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Due Date")
                .foregroundColor(.gray)
            HStack {
                DatePicker("", selection: $dueDate, displayedComponents: .date)
                    .datePickerStyle(CompactDatePickerStyle())
                    .labelsHidden()
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(10)
                    .foregroundColor(.white)
                Spacer() // Aligns DatePicker to the left
            }
        }
    }
}

/// **Priority Selector**
struct PrioritySelector: View {
    @Binding var priority: String
    let priorities: [String]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Priority")
                .foregroundColor(.gray)
            HStack {
                ForEach(priorities, id: \.self) { priorityOption in
                    Button(action: {
                        self.priority = priorityOption
                    }) {
                        Text(priorityOption)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .opacity(priority == priorityOption ? 1.0 : 0.6) // Highlight with opacity
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

/// **Cancel Button**
struct CancelButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text("Cancel")
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.gray.opacity(0.2))
                .foregroundColor(.white)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
    }
}

/// **Save Button**
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

/// **Priority Color Function (Matches Home Screen)**
func priorityColor(_ priority: String) -> Color {
    switch priority {
    case "High": return Color(red: 1.0, green: 59/255, blue: 48/255).opacity(0.2) // #FF3B30
    case "Medium": return Color(red: 1.0, green: 214/255, blue: 10/255).opacity(0.2) // #FFD60A
    case "Low": return Color(red: 48/255, green: 209/255, blue: 88/255).opacity(0.2) // #30D158
    default: return Color.gray.opacity(0.2)
    }
}
