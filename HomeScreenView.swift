import SwiftUI

// Task Model
struct Task: Identifiable {
    let id = UUID()
    let title: String
    let dueDate: String
    let priority: String
    let description: String
}

struct HomeScreenView: View {
    @State private var selectedFilter: String = "All" // Track selected filter
    
    // Mock Task Data
    let tasks = [
        Task(title: "Design System Update",
             dueDate: "Mar 15, 2025",
             priority: "High",
             description: "Revamp the UI components and improve theme consistency across all views. Ensure new components match the latest design system."),
        
        Task(title: "Team Meeting",
             dueDate: "Mar 16, 2025",
             priority: "Medium",
             description: "Weekly sync-up to discuss project progress, review completed tasks, and plan upcoming features for the next sprint."),
        
        Task(title: "Project Review",
             dueDate: "Mar 18, 2025",
             priority: "Low",
             description: "Analyze overall performance of the current app version, review user feedback, and prepare a roadmap for future improvements.")
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background Gradient
                LinearGradient(gradient: Gradient(colors: [Color.black, Color(red: 18/255, green: 18/255, blue: 18/255)]),
                               startPoint: .top,
                               endPoint: .bottom)
                    .ignoresSafeArea()
                
                VStack {
                    HStack {
                        Text("Your Tasks")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        // Navigation to Settings
                        NavigationLink(destination: SettingsView()) {
                            Image(systemName: "gearshape.fill")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    // Interactive Filter Buttons
                    HStack {
                        FilterButton(title: "All", isActive: selectedFilter == "All") {
                            selectedFilter = "All"
                        }
                        FilterButton(title: "Completed", isActive: selectedFilter == "Completed") {
                            selectedFilter = "Completed"
                        }
                        FilterButton(title: "Pending", isActive: selectedFilter == "Pending") {
                            selectedFilter = "Pending"
                        }
                    }
                    .padding(.vertical, 10)
                    
                    // Task List (Now Tasks Are Tappable)
                    ScrollView {
                        VStack(spacing: 10) {
                            ForEach(tasks) { task in
                                NavigationLink(destination: TaskDetailsView(task: task)) {
                                    TaskRow(task: task)
                                }
                            }
                        }
                    }
                    
                    Spacer()
                    
                    // Floating Add Button
                    NavigationLink(destination: CreateTaskView()) {
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.white)
                            .padding()
                            .background(Circle().fill(Color.white.opacity(0.2)))
                            .overlay(
                                Circle().stroke(Color.white, lineWidth: 1)
                            )
                    }
                    .padding(.bottom, 20)
                }
                .padding(.horizontal)
            }
        }
    }
}

// MARK: - Task Row View (Now Wrapped in NavigationLink)
struct TaskRow: View {
    let task: Task
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(task.title)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text("Due: \(task.dueDate)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            
            // Priority Indicator
            Text(task.priority)
                .font(.subheadline)
                .padding(8)
                .background(priorityColor(task.priority))
                .foregroundColor(.white)
                .cornerRadius(10)
        }
        .padding()
        .background(Color.clear)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.white.opacity(0.3), lineWidth: 1)
        )
        .padding(.horizontal)
    }
    
    // Priority Color Helper Function (Matches Home Screen)
    func priorityColor(_ priority: String) -> Color {
        switch priority {
        case "High": return Color(red: 1.0, green: 59/255, blue: 48/255).opacity(0.33)
        case "Medium": return Color(red: 1.0, green: 214/255, blue: 10/255).opacity(0.33)
        case "Low": return Color(red: 48/255, green: 209/255, blue: 88/255).opacity(0.33)
        default: return Color.gray.opacity(0.2)
        }
    }
}

// MARK: - Updated Filter Button View
struct FilterButton: View {
    let title: String
    let isActive: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .fontWeight(.thin) // Matches priority button style
                .foregroundColor(.white) // Always white text
                .opacity(isActive ? 1.0 : 0.6) // Highlight with opacity
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .background(Color.white.opacity(isActive ? 0.3 : 0.1)) // Subtle highlight
                .cornerRadius(20)
                .animation(.easeInOut(duration: 0.2), value: isActive) // Smooth transition
        }
    }
}
