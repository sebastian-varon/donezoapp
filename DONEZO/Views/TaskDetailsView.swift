import SwiftUI

struct TaskDetailsView: View {
    let task: Task // Static Task Model (No Core Data)

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
                Text(task.title)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.bottom, 5)
                
                // Due Date
                HStack {
                    Image(systemName: "calendar")
                        .foregroundColor(.gray)
                    Text("Due: \(task.dueDate)")
                        .foregroundColor(.gray)
                }
                
                // Priority Badge
                Text(task.priority)
                    .font(.subheadline)
                    .padding()
                    .background(priorityColor(task.priority))
                    .cornerRadius(10)
                    .foregroundColor(.white)
                
                // Description Section (Placeholder)
                Text("Description")
                    .font(.headline)
                    .foregroundColor(.gray)
                
                Text("This is a placeholder description. In a real implementation, task details would be fetched from Core Data.")
                    .font(.body)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(10)
                
                Spacer()
            }
            .padding(.horizontal)
        }
    }
    
    // Priority Color Helper
    func priorityColor(_ priority: String) -> Color {
        switch priority {
        case "High": return Color.red.opacity(0.2)
        case "Medium": return Color.yellow.opacity(0.2)
        case "Low": return Color.green.opacity(0.2)
        default: return Color.gray.opacity(0.2)
        }
    }
}
