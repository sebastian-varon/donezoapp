import SwiftUI

struct SettingsView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var notificationsEnabled = true
    @AppStorage("isDarkMode") private var darkModeEnabled = true

    var body: some View {
        ZStack {
            Color.background(for: colorScheme)
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 20) {
                // Title
                Text("Settings")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color.primaryText(for: colorScheme))
                
                // Notification Toggle
                SettingsToggle(title: "Enable Notifications", isOn: $notificationsEnabled, colorScheme: colorScheme)
                
                // Dark Mode Toggle
                SettingsToggle(title: "Enable Dark Mode", isOn: $darkModeEnabled, colorScheme: colorScheme)
                
                // About Section
                VStack(alignment: .leading, spacing: 10) {
                    Text("About")
                        .font(.headline)
                        .foregroundColor(Color.secondaryText(for: colorScheme))
                    
                    Text("Donezo is a modern and minimalistic task management app designed to help you stay productive and focus on what really matters. Built with SwiftUI by:")
                        .foregroundColor(Color.primaryText(for: colorScheme))
                        .font(.body)
                    
                    Text("Anthony Aristy, Nikola Varicak & Sebastian Varon")
                        .foregroundColor(Color.secondaryText(for: colorScheme))
                        .font(.subheadline)
                }
                .padding()
                .background(Color.card(for: colorScheme))
                .cornerRadius(10)
                
                Spacer()
            }
            .padding(.horizontal)
        }
    }
}

// MARK: - Toggle Setting Row
struct SettingsToggle: View {
    let title: String
    @Binding var isOn: Bool
    var colorScheme: ColorScheme

    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(Color.primaryText(for: colorScheme))
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .toggleStyle(SwitchToggleStyle(tint: .blue))
        }
        .padding()
        .background(Color.card(for: colorScheme))
        .cornerRadius(10)
    }
}
