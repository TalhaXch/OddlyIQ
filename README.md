# ODDLYIQ

Fast-paced brain training game. Find the odd one out before time runs out.

## Game Overview

ODDLYIQ tests visual perception, pattern recognition, and speed under pressure. Identify the ONE item that differs from the rest in increasingly challenging grids.

### Game Modes

- **Classic**: Mixed color and shape challenges
- **Color**: Pure color perception (standardized square tiles)
- **Shape**: Geometric variations (corner radius, rotation, aspect ratio)

### Difficulty Tiers

| Tier | Levels | Grid Size | Time |
|------|--------|-----------|------|
| Beginner | 1-10 | 4-10 | 10-12s |
| Intermediate | 11-30 | 9-21 | 8-10s |
| Advanced | 31-70 | 16-32 | 6-8s |
| Expert | 71+ | 28-36 | 3-6s |

## Architecture

Clean, feature-based architecture with strict separation of concerns.

```
lib/
├── core/
│   ├── config/           # Game and difficulty configuration
│   └── validators/       # Color/shape validation logic
├── game/
│   ├── models/           # GameTile, GameLevel, GameState
│   ├── controllers/      # Riverpod state management
│   └── services/         # LevelGenerator, ScoreService
└── ui/
    ├── screens/          # Splash, Home, Game, GameOver
    ├── widgets/          # TileWidget, GameGrid, GameHeader
    └── theme/            # AppTheme
```

### Key Services

- **LevelGenerator**: Creates validated levels with guaranteed fairness
- **ColorValidator**: HSL-based color difference validation
- **ShapeValidator**: Geometric threshold validation
- **LevelValidator**: Ensures exactly one perceivable odd item
- **ScoreService**: Tier-based scoring with combo multipliers

### State Management

Riverpod StateNotifier pattern. All game logic in `GameController`, UI is purely reactive.

## How to Run

```bash
# Install dependencies
flutter pub get

# Run the app
flutter run
```

## Tech Stack

- Flutter 3.7+
- Riverpod (state management)
- SharedPreferences (high score persistence)
