import SwiftUI

struct HomeScreenView: View {

    @State private var selectedFilter: String = "All"
    @State private var selectedSort: String = "Due Date"

    // Static tasks (No Core Data)
    @State private var tasks = [
        Task(title: "Design System Update", dueDate: "Mar 15, 2025", priority: "High"),
        Task(title: "Team Meeting", dueDate: "Mar 16, 2025", priority: "Medium"),
        Task(title: "Project Review", dueDate: "Mar 18, 2025", priority: "Low")
    ]

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("Your Tasks")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)

                    Spacer()

                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gearshape.fill")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.gray)
                    }
                }

                // Sorting Picker
                Picker("Sort by", selection: $selectedSort) {
                    Text("Due Date").tag("Due Date")
                    Text("Priority").tag("Priority")
                    Text("Title").tag("Title")
                }
                .pickerStyle(.segmented)
                .padding(.vertical, 10)

                // Filters
                HStack {
                    FilterButton(title: "All", isActive: selectedFilter == "All") { selectedFilter = "All" }
                    FilterButton(title: "Completed", isActive: selectedFilter == "Completed") { selectedFilter = "Completed" }
                    FilterButton(title: "Pending", isActive: selectedFilter == "Pending") { selectedFilter = "Pending" }
                }
                .padding(.vertical, 10)

                // Task List
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(tasks, id: \.id) { task in
                            TaskRow(task: task)
                        }
                    }
                }

                Spacer()
            }
            .padding(.horizontal)
            .background(Color.black.ignoresSafeArea())
        }
    }
}

// Dummy Task Model (No Core Data)
struct Task: Identifiable {
    let id = UUID()
    let title: String
    let dueDate: String
    let priority: String
}
