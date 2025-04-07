import SwiftUI

struct HomeScreenView: View {

    @State private var selectedFilter: String = "All"
    @State private var selectedSort: String = "Due Date"
    @State private var needsRefresh: Bool = false
    @State private var refreshID = UUID()
    @State private var violinTilt: Double = -10
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Task.dueDate, ascending: true)],
        animation: .default
    ) private var tasks: FetchedResults<Task>

    private var filteredTasks: [Task] {
        var filtered = tasks.map { $0 }

        switch selectedFilter {
        case "Completed":
            filtered = filtered.filter { $0.isCompleted }
        case "Pending":
            filtered = filtered.filter { !$0.isCompleted }
        default:
            break
        }

        switch selectedSort {
        case "Priority":
            return filtered.sorted {
                priorityWeight($0.priority) < priorityWeight($1.priority)
            }
        case "Title":
            return filtered.sorted { ($0.title ?? "") < ($1.title ?? "") }
        default:
            return filtered.sorted { ($0.dueDate ?? Date()) < ($1.dueDate ?? Date()) }
        }
    }

    private func priorityWeight(_ priority: String?) -> Int {
        switch priority {
        case "High": return 0
        case "Medium": return 1
        case "Low": return 2
        default: return 3
        }
    }

    var body: some View {
        NavigationView {
            ZStack {
                Color.background(for: colorScheme)
                    .ignoresSafeArea()
                VStack {
                    HStack {
                        Text("Your Tasks")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color.primaryText(for: colorScheme))

                        Spacer()

                        NavigationLink(destination: SettingsView()) {
                            Image(systemName: "gearshape.fill")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(Color.secondaryText(for: colorScheme))
                        }
                    }

                    Picker("Sort by", selection: $selectedSort) {
                        Text("Due Date").tag("Due Date")
                        Text("Priority").tag("Priority")
                        Text("Title").tag("Title")
                    }
                    .pickerStyle(.segmented)
                    .padding(.vertical, 10)

                    HStack {
                        FilterButton(title: "All", isActive: selectedFilter == "All") {
                            applyFilter("All")
                        }
                        FilterButton(title: "Completed", isActive: selectedFilter == "Completed") {
                            applyFilter("Completed")
                        }
                        FilterButton(title: "Pending", isActive: selectedFilter == "Pending") {
                            applyFilter("Pending")
                        }
                    }
                    .padding(.vertical, 10)

                    ScrollView {
                        if filteredTasks.isEmpty {
                            VStack(spacing: 20) {
                                Text("🎻")
                                    .font(.system(size: 80))
                                    .rotationEffect(.degrees(violinTilt))
                                    .animation(
                                        Animation.easeInOut(duration: 2)
                                            .repeatForever(autoreverses: true),
                                        value: violinTilt
                                    )
                                    .onAppear {
                                        violinTilt = 10
                                    }

                                Text("The world's smallest violin is playing for your empty task list...")
                                    .font(.headline)
                                    .foregroundColor(Color.secondaryText(for: colorScheme).opacity(0.8))

                                Text("Tap the + to give it something to play for.")
                                    .font(.subheadline)
                                    .foregroundColor(Color.secondaryText(for: colorScheme).opacity(0.8))
                            }
                            .padding()
                        } else {
                            VStack(spacing: 10) {
                                ForEach(filteredTasks) { task in
                                    NavigationLink(destination: TaskDetailsView(task: task, needsRefresh: $needsRefresh)) {
                                        TaskRow(task: task)
                                            .transition(.opacity)
                                    }
                                }
                            }
                            .animation(.easeInOut(duration: 0.3), value: filteredTasks)
                        }
                    }
                    .id(refreshID)

                    Spacer()

                    NavigationLink(destination: CreateTaskView(needsRefresh: $needsRefresh)) {
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(Color.primaryText(for: colorScheme))
                            .padding()
                            .background(Circle().fill(Color.white.opacity(0.2)))
                            .overlay(
                                Circle().stroke(Color.primaryText(for: colorScheme), lineWidth: 1)
                            )
                    }
                    .padding(.bottom, 20)
                }
                .padding(.horizontal)
                .animation(nil, value: filteredTasks)
            }
        }
        .onChange(of: needsRefresh) {
            refreshID = UUID()
        }
    }

    private func applyFilter(_ filter: String) {
        selectedFilter = filter
    }
}

// MARK: - Task Row View
struct TaskRow: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var task: Task
    @State private var isCompleted: Bool
    @Environment(\.colorScheme) var colorScheme

    init(task: Task) {
        self.task = task
        _isCompleted = State(initialValue: task.isCompleted)
    }

    var body: some View {
        HStack {
            Button(action: toggleCompletion) {
                Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isCompleted ? .green : .gray)
                    .font(.system(size: 24))
            }

            VStack(alignment: .leading) {
                Text(task.title ?? "Untitled Task")
                    .font(.headline)
                    .foregroundColor(Color.primaryText(for: colorScheme))
                    .strikethrough(isCompleted, color: .white)

                if let dueDate = task.dueDate {
                    Text("Due: \(dueDate.formatted(date: .long, time: .omitted))")
                        .font(.subheadline)
                        .foregroundColor(Color.secondaryText(for: colorScheme))

                    if dueDate < Date() {
                        Text("Overdue")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.red)
                    }
                } else {
                    Text("No due date")
                        .font(.subheadline)
                        .foregroundColor(Color.secondaryText(for: colorScheme))
                }
            }

            Spacer()

            Text(task.priority ?? "Unknown")
                .font(.subheadline)
                .padding(8)
                .background(priorityColor(task.priority ?? "Unknown"))
                .foregroundColor(Color.primaryText(for: colorScheme))
                .cornerRadius(10)
        }
        .padding()
        .background(Color.card(for: colorScheme))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.secondaryText(for: colorScheme).opacity(0.3), lineWidth: 1)
        )
        .padding(.horizontal)
    }

    private func toggleCompletion() {
        withAnimation(.easeInOut(duration: 0.3)) {
            isCompleted.toggle()
            task.isCompleted = isCompleted
        }
        do {
            try viewContext.save()
        } catch {
            print("❌ Error saving completion state: \(error.localizedDescription)")
        }
    }

    func priorityColor(_ priority: String) -> Color {
        switch priority {
        case "High": return Color.red.opacity(0.33)
        case "Medium": return Color.yellow.opacity(0.33)
        case "Low": return Color.green.opacity(0.33)
        default: return Color.gray.opacity(0.2)
        }
    }
}

// MARK: - Filter Button View
struct FilterButton: View {
    
    @Environment(\.colorScheme) var colorScheme
    let title: String
    let isActive: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .fontWeight(.thin)
                .foregroundColor(Color.primaryText(for: colorScheme))
                .opacity(isActive ? 1.0 : 0.6)
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .background(
                    isActive
                    ? Color.primaryText(for: colorScheme).opacity(0.2)
                    : Color.secondaryText(for: colorScheme).opacity(0.1)
                )
                .cornerRadius(20)
                .animation(.easeInOut(duration: 0.2), value: isActive)
        }
    }
}
