# Chatify Repository Guidelines

## Project Overview

- **Framework**: Flutter
- **Primary Platforms**: Mobile (Android/iOS)
- **Design Goal**: Modern messaging experience inspired by WhatsApp and similar chat applications.

## Coding Conventions

1. **Language**: Dart for Flutter widgets and business logic.
2. **State Management**: Uses `flutter_bloc`. Prefer `BlocBuilder`, `BlocListener`, and `BlocConsumer` for UI reactions.
3. **File Structure**: Features are organized under `lib/features/<feature_name>` with `presentation`, `domain`, and `data` layers when applicable.
4. **Styling**: Leverage Theme data; avoid hard-coded colors unless part of a feature-specific palette.
5. **Internationalization**: Prepare strings for localization when practical; avoid embedding text in business logic.
6. **Null Safety**: The project is null-safe. Enforce strict analysis options and handle nullable data thoughtfully.

## UI/UX Principles

- **Responsive Layouts**: Ensure widgets scale across different device sizes.
- **Accessibility**: Provide semantic labels where needed and respect system font scaling.
- **Consistency**: Align with Material Design 3 principles unless a feature requires custom visuals.
- **Animations**: Use subtle, meaningful animations that enhance understanding without distracting.

## Testing Guidelines

- **Unit/Widget Tests**: Favor lightweight tests. Place under `test/` mirroring library structure.
- **Mocks/Stubs**: Use `mocktail` unless otherwise required. Keep mocks narrowly scoped.

## Tooling & Scripts

- **Linting**: Run `flutter analyze` before committing.
- **Formatting**: Use `dart format .` to maintain consistent style.
- **Build**: Standard `flutter build <target>` commands.

## Branch & Commit Practices

- **Branch Naming**: `feature/<feature-name>`, `fix/<issue>`, or `chore/<task>`.
- **Commit Messages**: Use imperative mood—e.g., “Add glassmorphism for phone input page.”

## Additional Notes

- Document complex widgets or cubits with inline comments when the intent isn’t obvious.
- Keep dependency additions minimal and justify them in PR descriptions.
