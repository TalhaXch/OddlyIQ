# ODDLYIQ

A fast-paced brain game where players must identify the one item that differs from the rest in a grid of visual elements. Test your visual perception, pattern recognition, and speed!

## 🎮 Game Overview

ODDLYIQ challenges players to find the odd one out among a grid of similar items before time runs out. As you progress through levels, the game becomes increasingly challenging with:

- **Tier-Based Progression**: 4 difficulty tiers (Beginner → Expert) spanning 100+ levels
- **Subtle Visual Deception**: Micro-differences in color, rotation, size, and opacity
- **Pattern Misdirection**: Anti-pattern tricks where the odd item may look more "normal"
- **Multi-Attribute Challenges**: Up to 3 simultaneous subtle differences
- **Exponential Difficulty Scaling**: Each tier introduces new deception mechanics
- **Time Pressure**: Reducing time limits with penalties for wrong answers

## ✨ Features

- **Multiple Puzzle Types**: Shapes, colors, icons, numbers, and symbols
- **4-Tier Difficulty System**: Beginner (1-10), Intermediate (11-30), Advanced (31-70), Expert (71+)
- **Advanced Difficulty Mechanics**:
  - Subtle color shading (< 5% HSL variance)
  - Micro-rotations (1-8 degrees)
  - Scale and opacity variations
  - Pattern misdirection and visual traps
- **Sophisticated Scoring**: Exponential rewards for higher tiers and combo streaks
- **Wrong Answer Penalties**: Time deductions that increase with difficulty
- **Score Tracking**: Persistent high score with tier-based bonuses
- **Modern UI**: Clean, premium design with smooth animations
- **Portrait Optimized**: Designed specifically for mobile portrait orientation

## 🏗️ Architecture

The project follows a clean, feature-based architecture for scalability and maintainability:

### Folder Structure

```
lib/
├── core/
│   ├── constants/           # App-wide constants
│   │   └── app_constants.dart
│   ├── controllers/         # State management (Riverpod)
│   │   └── game_controller.dart
│   ├── models/              # Data models
│   │   ├── game_item.dart
│   │   ├── game_level.dart
│   │   └── game_state.dart
│   ├── services/            # Business logic services
│   │   ├── difficulty_service.dart
│   │   ├── level_generator_service.dart
│   │   ├── scoring_service.dart
│   │   └── storage_service.dart
│   └── theme/               # UI theme configuration
│       └── app_theme.dart
├── features/                # Feature modules
│   ├── game/
│   │   ├── game_screen.dart
│   │   └── widgets/
│   │       ├── game_header.dart
│   │       └── game_item_widget.dart
│   ├── game_over/
│   │   └── game_over_screen.dart
│   ├── home/
│   │   └── home_screen.dart
│   └── splash/
│       └── splash_screen.dart
└── main.dart
```

### Architecture Layers

1. **Presentation Layer** (`features/`): UI components organized by feature
2. **State Management** (`core/controllers/`): Riverpod-based state management
3. **Business Logic** (`core/services/`): Reusable services for game mechanics
4. **Data Models** (`core/models/`): Type-safe data structures
5. **Theme** (`core/theme/`): Centralized styling and design tokens

### Design Patterns

- **Feature-Based Organization**: Each feature is self-contained with its UI and widgets
- **Service Layer Pattern**: Business logic separated from UI
- **Repository Pattern**: Storage service abstracts data persistence
- **State Management**: Riverpod for reactive, testable state management
- **Separation of Concerns**: Clear boundaries between UI, logic, and data

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.7.2 or higher)
- Dart SDK (included with Flutter)
- A code editor (VS Code, Android Studio, etc.)

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd oddlyiq
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

### Running on Specific Platform

```bash
# Android
flutter run -d android

# iOS
flutter run -d ios

# Windows
flutter run -d windows

# macOS
flutter run -d macos

# Web
flutter run -d chrome
```

## 🎨 Design Philosophy

### UI/UX Principles

- **Modern & Minimal**: Clean interfaces without clutter
- **Premium Feel**: Sophisticated color palette and typography
- **Accessibility**: High contrast and readable text
- **Responsive**: Adapts to different screen sizes
- **Smooth Animations**: Subtle transitions enhance user experience
- **Dark Theme**: Reduces eye strain during extended play

### Color Palette

- Primary: Indigo (#6366F1)
- Secondary: Purple (#8B5CF6)
- Background: Dark Navy (#0F172A)
- Surface: Slate (#1E293B)
- Success: Green (#10B981)
- Error: Red (#EF4444)

## 🔧 Configuration

### Difficulty Settings

ODDLYIQ features a sophisticated tier-based difficulty system that progressively challenges players:

#### Difficulty Tiers

**Beginner (Levels 1-10)**
- Grid: 6-12 items
- Time: 6-10 seconds
- Features: Clear visual differences, basic pattern recognition
- Feedback: Full visual feedback on selections

**Intermediate (Levels 11-30)**
- Grid: 12-20 items
- Time: 5-8 seconds
- Features: Subtle color variations, micro-rotations, multi-attribute differences
- Pattern misdirection begins
- Wrong answers penalize 2 seconds

**Advanced (Levels 31-70)**
- Grid: 20-25 items
- Time: 4-6 seconds
- Features: 2-3 simultaneous attribute differences (color, rotation, size, opacity)
- Heavy pattern misdirection (odd item may be most "normal")
- Limited feedback in later stages
- Wrong answers penalize 3 seconds

**Expert (Levels 71+)**
- Grid: 25-36 items
- Time: 3-5 seconds
- Features: Minimal visual differences (<5% variance)
- 3 simultaneous micro-attributes
- No selection feedback
- Maximum pattern deception
- Wrong answers penalize 4 seconds

#### Advanced Difficulty Mechanics

- **Subtle Color Shading**: HSL variations < 5% in hue/saturation/lightness
- **Micro-Rotations**: 1-8 degree rotations
- **Scale Variance**: 3-12% size differences
- **Opacity Shifts**: 2-6% transparency differences
- **Pattern Misdirection**: Normal items have noise while odd item is perfect (or vice versa)
- **Multi-Attribute Logic**: Up to 3 simultaneous differences at expert tier

### Scoring System

Exponential scoring rewards higher-level play:

- **Base Score**: 100 (Beginner) → 1000 (Expert)
- **Level Multiplier**: Exponential scaling (1.0x → 13.0x+)
- **Time Bonus**: 10-100 points per second remaining (tier-based)
- **Combo Bonus**: Exponential (50 × 1.5^streak + level bonus)
- **Tier Bonus**: 0 (Beginner) → 5000 (Expert)
- **Wrong Answer Penalty**: -1 to -4 seconds based on tier

### Example Scoring

- Level 5 correct with 5s remaining, 3 combo: ~600 points
- Level 25 correct with 4s remaining, 8 combo: ~8,000 points
- Level 75 correct with 3s remaining, 15 combo: ~50,000+ points

## 🧪 Testing

Run tests with:

```bash
flutter test
```

## 📱 Build for Release

### Android

```bash
flutter build apk --release
```

### iOS

```bash
flutter build ios --release
```

## 🛠️ Tech Stack

- **Framework**: Flutter
- **Language**: Dart
- **State Management**: Riverpod
- **Storage**: SharedPreferences
- **Null Safety**: Enabled

## 📄 License

This project is available for use as needed.

---

**Built with Flutter** 💙
