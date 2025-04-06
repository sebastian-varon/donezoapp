import SwiftUI

extension Color {
    static func background(for scheme: ColorScheme) -> Color {
        scheme == .dark
            ? Color(red: 18/255, green: 18/255, blue: 18/255)
            : Color(UIColor.systemGroupedBackground)
    }

    static func card(for scheme: ColorScheme) -> Color {
        scheme == .dark
            ? Color.white.opacity(0.1)
            : Color(UIColor.secondarySystemGroupedBackground)
    }

    static func primaryText(for scheme: ColorScheme) -> Color {
        scheme == .dark ? .white : .black
    }

    static func secondaryText(for scheme: ColorScheme) -> Color {
        scheme == .dark ? .gray : .gray
    }
}
