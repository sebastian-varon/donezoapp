import SwiftUI

struct LaunchScreenView: View {
    @State private var isActive = false
    
    var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(gradient: Gradient(colors: [Color.black, Color(red: 18/255, green: 18/255, blue: 18/255)]),
                           startPoint: .top,
                           endPoint: .bottom)
                .ignoresSafeArea()
            
            if isActive {
                HomeScreenView() // Fade transition to Home
                    .transition(.opacity)
            } else {
                VStack {
                    Spacer()
                    
                    Image("Logo") // App Logo
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250, height: 250) // Match wireframe
                        .padding(.bottom, 30)
                    
                    Text("Tap anywhere to continue")
                        .font(.title2)
                        .fontWeight(.light)
                        .foregroundColor(.white.opacity(0.6))
                        .padding(.top, 10)
                    
                    Spacer()
                    
                    Text("By Anthony Aristy, Nikola Varicak & Sebastian Varon")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .padding(.bottom, 30)
                        .opacity(0.8)
                }
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        isActive = true
                    }
                }
            }
        }
    }
}
