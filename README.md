# Solve Cube

Solve Cube is an offline-first, no-account twisty-puzzle assistant. The planned first release includes 2×2–7×7 cubes, Pyraminx (triangle), and Mirror Cube. Gear Cube is listed as coming soon.

## Planned workflow

1. Choose a puzzle.
2. Enter its state using guided camera capture or an editable colour/piece palette.
3. Validate the entered state before solving.
4. Compute a puzzle-specific solution and replay-check it.
5. Follow slow automatic playback or step manually, with previous/next, pause/resume, move notation, and plain-language instructions.

## Engineering principles

- No login and no required cloud API.
- Solver logic runs locally.
- A puzzle is advertised as solvable only when its solver and state validator are implemented and covered by tests.
- Large-cube and shape-mod puzzles use puzzle-specific engines; they must not be routed through a standard 3×3 solver.
- A release is not marked stable until its platform builds and the solver/input/playback test suites pass.

## First-release targets

Android, iOS, Windows, macOS, Linux, followed by a web version.

## Versioning

Semantic Versioning: MAJOR.MINOR.PATCH. The first stable release is intended to be 1.0.0. This repository is currently at the project bootstrap stage; no 1.0.0 release is published yet.

## Status

The repository has been initialized. The application implementation, solver integrations, device validation, and release artifacts are still to be completed.
