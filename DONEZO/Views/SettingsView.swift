import SwiftUI

struct SettingsView: View {
    @State private var notificationsEnabled = true
    @State private var darkModeEnabled = true
    
    var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(gradient: Gradient(colors: [Color.black, Color(red: 18/255, green: 18/255, blue: 18/255)]),
                           startPoint: .top,
                           endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 20) {
                // Title
                Text("Settings")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                // Notification Toggle
                SettingsToggle(title: "Enable Notifications", isOn: $notificationsEnabled)
                
                // Dark Mode Toggle
                SettingsToggle(title: "Enable Dark Mode", isOn: $darkModeEnabled)
                
                // About Section
                VStack(alignment: .leading, spacing: 10) {
                    Text("About")
                        .font(.headline)
                        .foregroundColor(.gray)
                    
                    Text("Donezo is a modern and minimalistic task management app designed to help you stay productive and focus on what really matters. Built with SwiftUI by:")
                        .foregroundColor(.white)
                        .font(.body)
                    
                    Text("Anthony Aristy, Nikola Varicak & Sebastian Varon")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                }
                .padding()
                .background(Color.white.opacity(0.1))
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
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.white)
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .toggleStyle(SwitchToggleStyle(tint: .blue))
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(10)
    }
}
