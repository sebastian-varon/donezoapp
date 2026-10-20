# DONEZO

A minimalist iOS task manager built with SwiftUI. Create tasks with a due date, priority and optional reminder, then filter and sort your list to focus on what matters next.

## Features

- **Create and edit tasks** with title, description, due date and priority (High, Medium, Low).
- **Reminders:** schedule a local notification for any task at a chosen date and time.
- **Filter** by All, Pending or Completed, and **sort** by due date, priority or title.
- **Mark tasks done** with a completion system that updates the list instantly.
- **Saved on device** with Core Data, so tasks persist between launches.
- **Settings:** turn notifications on or off and switch between light and dark mode.
- Colour-coded priorities and a custom launch screen.

## Tech stack

- Swift and SwiftUI
- Core Data (`PersistenceController`, `@FetchRequest`)
- UserNotifications (`NotificationManager` as the notification center delegate)
- Xcode, targeting iOS 18

## Project structure

```
DONEZO/
  DONEZOApp.swift             app entry point
  PersistenceController.swift Core Data stack
  NotificationManager.swift   reminder scheduling and permissions
  Color+Theme.swift           light and dark theme colours
  Views/                      Home, Create/Edit Task, Task Details, Settings, Launch
```

## Run it

Open `DONEZO.xcodeproj` in Xcode 16 or later and run on an iOS 18 simulator or device.

## Team

Built by a team of three:
- **Sebastian Varon:** project setup and structure, Core Data persistence, task completion, filtering logic, the reminder notification system and the Settings screen.
- **Anthony Aristy:** home screen UI, filters and sorting UI, task details and edit flows.
- **Nikola Varicak:** home and launch screens, create and edit task UI, dark/light theme.
