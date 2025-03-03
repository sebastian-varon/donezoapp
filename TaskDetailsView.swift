import SwiftUI

struct TaskDetailsView: View {
    let task: Task // Receive task from HomeScreenView
    
    var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(gradient: Gradient(colors: [Color.black, Color(red: 18/255, green: 18/255, blue: 18/255)]),
                           startPoint: .top,
                           endPoint: .bottom)
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
                
                Text("Description")
                    .font(.headline)
                    .foregroundColor(.gray)
                
                Text(task.description)
                    .font(.body)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(10)
                
                Spacer()
                
                // Edit & Delete Buttons
                HStack {
                    Button(action: {
                        print("Edit Task")
                    }) {
                        Text("Edit Task")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white.opacity(0.2))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    Button(action: {
                        print("Delete Task")
                    }) {
                        Text("Delete Task")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
    
    // Priority Color Function (Matches Home Screen)
    func priorityColor(_ priority: String) -> Color {
        switch priority {
        case "High": return Color(red: 1.0, green: 59/255, blue: 48/255).opacity(0.2)
        case "Medium": return Color(red: 1.0, green: 214/255, blue: 10/255).opacity(0.2)
        case "Low": return Color(red: 48/255, green: 209/255, blue: 88/255).opacity(0.2)
        default: return Color.gray.opacity(0.2)
        }
    }
}
