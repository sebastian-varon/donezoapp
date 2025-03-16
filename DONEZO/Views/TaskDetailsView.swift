import SwiftUI
import CoreData

struct TaskDetailsView: View {
<<<<<<< HEAD
    let task: Task // Static Task Model (No Core Data)
=======
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) var dismiss

    let task: Task
    @Binding var needsRefresh: Bool
>>>>>>> 9ff523ab0549bd215f78e795c50798b54da4569f

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.black, Color(red: 18/255, green: 18/255, blue: 18/255)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 20) {
                
                // Title Section
                Text("Task Details")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                // Task Name
                Text(task.title ?? "Untitled Task")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.bottom, 5)
                
                // Due Date
                HStack {
                    Image(systemName: "calendar")
                        .foregroundColor(.gray)
                    Text("Due: \((task.dueDate ?? Date()).formatted(date: .long, time: .omitted))")
                        .foregroundColor(.gray)
                }
                
                // Priority Badge
                Text(task.priority ?? "Unknown")
                    .font(.subheadline)
                    .padding()
                    .background(priorityColor(task.priority ?? "Unknown"))
                    .cornerRadius(10)
                    .foregroundColor(.white)
                
<<<<<<< HEAD
                // Description Section (Placeholder)
=======
                // Description Section
>>>>>>> 9ff523ab0549bd215f78e795c50798b54da4569f
                Text("Description")
                    .font(.headline)
                    .foregroundColor(.gray)
                
<<<<<<< HEAD
                Text("This is a placeholder description. In a real implementation, task details would be fetched from Core Data.")
=======
                Text(task.taskDescription ?? "No description provided.")
>>>>>>> 9ff523ab0549bd215f78e795c50798b54da4569f
                    .font(.body)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(10)
                
                Spacer()
<<<<<<< HEAD
=======
                
                // Edit & Delete Buttons
                HStack {
                    NavigationLink(destination: CreateTaskView(task: task, needsRefresh: $needsRefresh)) {
                        Text("Edit Task")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(UIColor.systemGray4))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    Button(action: {
                        deleteTask()
                    }) {
                        Text("Delete Task")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
>>>>>>> 9ff523ab0549bd215f78e795c50798b54da4569f
            }
            .padding(.horizontal)
        }
    }
    
<<<<<<< HEAD
    // Priority Color Helper
=======
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
    
>>>>>>> 9ff523ab0549bd215f78e795c50798b54da4569f
    func priorityColor(_ priority: String) -> Color {
        switch priority {
        case "High": return Color.red.opacity(0.2)
        case "Medium": return Color.yellow.opacity(0.2)
        case "Low": return Color.green.opacity(0.2)
        default: return Color.gray.opacity(0.2)
        }
    }
}
