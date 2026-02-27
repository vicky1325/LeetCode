# Graph Quest iOS (LeetCode Hard - Graphs)

Graph Quest is an interactive SwiftUI mini-game that teaches players how to solve **LeetCode 1192: Critical Connections in a Network**.

## Game loop

1. Player enters mini challenge rounds.
2. Each round shows a graph visual and asks a focused concept question:
   - cycle recognition
   - bridge intuition
   - Tarjan DFS low-link logic
3. Player gets immediate feedback + explanation.
4. Final boss unlocks the complete hard-question solution flow.

## Features

- SwiftUI interface designed for iPhone/iPad.
- Visual graph canvas with nodes and highlighted bridge candidates.
- Multiple-choice interaction with hint and explanation panel.
- Score tracking and progression.
- Final solution summary with algorithmic steps and complexity.

## File structure

- `GraphQuestIOS/GraphQuestApp.swift` – app entry point.
- `GraphQuestIOS/ContentView.swift` – core UI and interactive gameplay.
- `GraphQuestIOS/GameModels.swift` – graph + challenge data models.
- `GraphQuestIOS/GameViewModel.swift` – challenge progression and scoring state.

## Run

1. In Xcode, create a new **iOS App (SwiftUI)** project named `GraphQuestIOS`.
2. Replace generated Swift files with files from this folder.
3. Build and run on an iOS simulator/device.

This repository currently provides the gameplay implementation source files ready for drop-in use.
