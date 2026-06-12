# Werewolf

A native iOS companion app that helps a human moderator run the tabletop social-deduction party game **Werewolf** (a.k.a. Mafia) in person. It tracks players, role assignments, and night actions (kills and saves), resolves who lives or dies each night, and detects when the game ends.

This is **not** a standalone playable game — it's a moderator's tool for an in-person session.

## Features

- Enter the number of players and name each one.
- Assign roles from six types: **werewolf**, **villager**, **bodyguard**, **witch**, **seeker**, **hunter**.
- Apply night actions per role, modeled as a status bitmask:
  - 🐺 Werewolves kill
  - ☠️ Witch kill
  - 🔫 Hunter kill
  - 🛡️ Bodyguard save
  - ⚱️ Witch save
- Automatic death resolution each night: a player dies if killed (werewolf or witch) and **not** saved (witch or bodyguard).
- Automatic end-game detection: villagers win when all werewolves are dead; werewolves win when they equal or outnumber the villagers.
- Night-by-night progression that resets survivor status and moves the dead aside.

## Gameplay flow

1. **Step 1** — the moderator enters the number of players.
2. **Step 2** — a table of player cards. Name each player, assign a role, and apply abilities each night. Advancing to the next night resolves deaths and checks for a winner.

## Tech stack

- **Language:** Swift 5.0
- **UI:** UIKit, programmatic Auto Layout (no SwiftUI)
- **Architecture:** MVVM + Coordinator
- **Minimum iOS:** 15.2
- **Devices:** iPhone and iPad
- **Dependencies:** none external — game rules live in an in-repo `WerewolfCore.framework`

## Project structure

```
Werewolf/
├── Werewolf.xcodeproj            # App + unit/UI test targets
├── WerewolfWorkspace.xcworkspace # Top-level workspace (open this)
├── WerewolfCore/                 # WerewolfCore.framework — game rules engine
│   └── WerewolfCore/Domain/      # Game, GameManager, Player, PlayerManager
├── Werewolf/                     # App source
│   ├── AppDelegate.swift         # @main entry point
│   ├── Coordinator/              # Navigation coordinators
│   ├── Presentation/             # Step 1 / Step 2 screens, cells, custom views
│   └── Extension/                # Small type extensions
├── WerewolfTests/                # App unit tests
└── WerewolfUITests/              # UI tests
```

The game logic is cleanly separated from the UI: rules, state, and resolution live entirely in the `WerewolfCore` framework, while the app target handles presentation and navigation.

### Core types (`WerewolfCore`)

- `Player` — id, name, role, alive flag, and a `status` bitmask of applied actions.
- `RoleType` / `ActionType` — the six roles and five night actions (actions use power-of-two raw values for bitmasking).
- `Game` — night counter, day/night phase, and the player rosters.
- `GameManager` — the rules engine: applying actions, resolving deaths (`checkDie`), advancing nights (`nextStage`), gating which role may use which action, and detecting the end of the game.

## Build & run

1. Open `WerewolfWorkspace.xcworkspace` in Xcode (the `WerewolfCore` framework links automatically).
2. Select the **Werewolf** scheme.
3. Run on an iOS 15.2+ simulator or device.

The app has no Storyboard main interface — `AppDelegate` builds the window and starts the coordinator at Step 1.

## Testing

Run the test suites from the command line:

```sh
xcodebuild test \
  -workspace WerewolfWorkspace.xcworkspace \
  -scheme Werewolf \
  -destination 'platform=iOS Simulator,name=iPhone 16'
```

> Note: the current test bundles contain only Xcode template stubs — real coverage is a work in progress.

## CI

`.github/workflows/ios.yml` is a reusable "Compare Code Coverage" workflow. It builds and tests the `Werewolf` scheme on `macos-latest` with code coverage enabled, extracts coverage via `xcrun xccov`, uploads the `.xcresult` artifacts, and writes a coverage-comparison table for two branches to the run summary.

## License

Released under the [MIT License](LICENSE).
