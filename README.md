# iOS Tic Tac Toe Game

A modern iOS implementation of the classic Tic Tac Toe game built using Swift and following MVVM architecture pattern.

## Project Overview

This project is a Tic Tac Toe game that demonstrates iOS development best practices, clean architecture, and proper separation of concerns. The game features user authentication, real-time gameplay, and statistics tracking.

## Directory Structure

```
tictactoe/
├── Models/
│   ├── GameSession.swift       # Game session data model
│   ├── GameStats.swift         # Statistics tracking model
│   └── User.swift              # User model for authentication
├── Scenes/
│   ├── Auth/                   # Authentication related views
│   ├── Game/                   # Game play related views
│   └── Stats/                  # Statistics and leaderboard views
├── Services/
│   ├── APIService.swift        # Network layer handling API calls
│   ├── AuthService.swift       # Authentication service
│   └── GameService.swift       # Game logic and state management
└── Utils/
└── Constants.swift             # App-wide constants and configurations
```

## Architecture

The project follows the MVVM (Model-View-ViewModel) architecture pattern with the following components:

### Key Components

1. **Models**: Plain Swift objects representing the data structure
2. **Services**: Handle business logic and API communications
3. **Scenes**: UI components organized by feature
4. **Utils**: Helper functions and constants

## Key Features

1. **Authentication System**
   - User registration and login
   - Session management
   - Secure token handling

2. **Game Implementation**
   - Real-time game state management
   - Turn-based gameplay
   - Win condition validation

3. **Statistics Tracking**
   - Player performance metrics
   - Game history
   - Leaderboard system

## Technical Highlights

1. **Clean Architecture**
   - Clear separation of concerns
   - Modular and testable components
   - SOLID principles implementation

2. **Modern Swift Features**
   - Protocol-oriented design
   - Strong type safety
   - Modern Swift concurrency

3. **UI Implementation**
   - Programmatic UI
   - Custom navigation flow
   - Responsive design


## Demo video
https://drive.google.com/file/d/1gFgUV0yxRzVKxYWkldviMdjaxEDcH7gH/view?usp=share_link

## How to Run

### Prerequisites
- macOS Ventura 13.0 or later
- Xcode 14.0 or later
- iOS 13.0+ device or simulator

### Installation Steps

1. **Clone the Repository**
   ```bash
   git clone https://github.com/Attique033/avrioc-tic-tac-toe-ios.git
   cd avrioc-tic-tac-toe-ios
   ```

2. **Open the Project**
   ```bash
   open tictactoe.xcodeproj
   ```
   Or double-click the `tictactoe.xcodeproj` file in Finder

3. **Update API URL** 
   - Open `Utils/Constants.swift`
   - Update the `baseURL` constant to point to your backend API endpoint

4. **Select Target Device**
   - Choose your target device/simulator from the scheme menu in Xcode
   - Ensure the selected device runs iOS 13.0 or later

4. **Build and Run**
   - Press `⌘ + R` to build and run the project
   - Or click the "Play" button in the top-left corner of Xcode

### First Launch

1. **Authentication**
   - On first launch, you'll be presented with the login screen
   - Create a new account or use test credentials:
     ```
     Username: test@example.com
     Password: password123
     ```

2. **Playing the Game**
   - Start a new game from the main menu
   - Take turns placing X's and O's
   - View your statistics in the Stats section

### Development Setup

1. **Environment Configuration**
   - No additional configuration files needed
   - All constants are defined in `Utils/Constants.swift`

2. **Debugging**
   - Use Xcode's built-in debugger
   - Console logs are available for tracking game state
   - Network calls can be monitored in the debug navigator

## Implementation Notes

- The app uses a custom navigation stack managed through `SceneDelegate`
- Authentication state determines the initial view controller
- Services are designed to be easily mockable for unit testing
- The project follows a feature-first folder structure for better scalability

## Disclaimer:

>GitHub Copilot was used during development to assist with boilerplate and repetitive tasks to improve development efficiency.
<br>
> AI tools were also used to help write project’s README.md.
Additionally, the project logo was generated using an AI-based image tool.
<br>
All design decisions, architecture, business logic, and final code implementations were crafted, reviewed, and tested manually to ensure they align with the case study objectives and reflect my own engineering work.
