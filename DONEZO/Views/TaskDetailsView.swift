import SwiftUI
import CoreData

struct TaskDetailsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme

    let task: Task
    @Binding var needsRefresh: Bool

    var body: some View {
        ZStack {
            Color.background(for: colorScheme)
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 20) {
                
                // Title Section
                Text("Task Details")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color.primaryText(for: colorScheme))
                
                // Task Name
                Text(task.title ?? "Untitled Task")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.primaryText(for: colorScheme))
                    .padding(.bottom, 5)
                
                // Due Date
                HStack {
                    Image(systemName: "calendar")
                        .foregroundColor(Color.secondaryText(for: colorScheme))
                    Text("Due: \((task.dueDate ?? Date()).formatted(date: .long, time: .omitted))")
                        .foregroundColor(Color.secondaryText(for: colorScheme))
                }
                
                // Priority Badge
                Text(task.priority ?? "Unknown")
                    .font(.subheadline)
                    .padding()
                    .background(priorityColor(task.priority ?? "Unknown"))
                    .cornerRadius(10)
                    .foregroundColor(Color.primaryText(for: colorScheme))
                
                // Description Section
                Text("Description")
                    .font(.headline)
                    .foregroundColor(Color.secondaryText(for: colorScheme))
                
                Text(task.taskDescription ?? "No description provided.")
                    .font(.body)
                    .foregroundColor(Color.primaryText(for: colorScheme))
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(10)
                
                Spacer()
                
                // Edit & Delete Buttons
                HStack {
                    NavigationLink(destination: CreateTaskView(task: task, needsRefresh: $needsRefresh)) {
                        Text("Edit Task")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(UIColor.systemGray4))
                            .foregroundColor(Color.primaryText(for: colorScheme))
                            .cornerRadius(10)
                    }
                    
                    Button(action: {
                        deleteTask()
                    }) {
                        Text("Delete Task")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .foregroundColor(Color.primaryText(for: colorScheme))
                            .cornerRadius(10)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
    
    private func deleteTask() {
        viewContext.delete(task)
        do {
            try viewContext.save()
            needsRefresh.toggle()
            dismiss()
        } catch {
            print("❌ Error deleting task: \(error.localizedDescription)")
        }
    }
    
    func priorityColor(_ priority: String) -> Color {
        switch priority {
        case "High": return Color.red.opacity(0.2)
        case "Medium": return Color.yellow.opacity(0.2)
        case "Low": return Color.green.opacity(0.2)
        default: return Color.gray.opacity(0.2)
        }
    }
}
