# Chatify - Clean Architecture Implementation

## Overview

This document describes the Clean Architecture implementation of the Chatify app, which allows users to open WhatsApp with Malaysian phone numbers.

## Architecture Principles

### 1. Dependency Rule

Dependencies point inward. Inner layers know nothing about outer layers:

- **Domain** → No dependencies (pure Dart)
- **Data** → Depends on Domain
- **Infrastructure** → Depends on Domain
- **Presentation** → Depends on Domain
- **App** → Depends on all layers (composition root)

### 2. Separation of Concerns

Each layer has a single, well-defined responsibility.

### 3. Testability

Business logic is independent of frameworks, making it easy to test.

## Layer Details

### Domain Layer (Business Logic)

**Location**: `lib/features/whatsapp_link/domain/`

**Purpose**: Contains the core business logic and rules. Framework-agnostic.

**Components**:

1. **Entities** (`entities/phone_number.dart`)

   - Represents a phone number with raw input and normalized format
   - Pure data objects with no business logic

2. **Repositories** (`repositories/phone_number_repository.dart`)

   - Abstract interface for phone number operations
   - Defines contract: `validateAndNormalize(String input)`

3. **Services** (`services/whatsapp_launcher.dart`)

   - Abstract interface for launching WhatsApp
   - Defines contract: `launch({required String number})`

4. **Use Cases** (`usecases/normalize_malaysian_number.dart`)

   - Single responsibility: normalize Malaysian phone numbers
   - Orchestrates repository calls
   - Implements business rules

5. **Value Objects** (`value_objects/launch_result.dart`)

   - Sealed class representing launch operation result
   - Type-safe error handling with `success` and `failed` states

6. **Exceptions** (`exceptions/invalid_phone_number_exception.dart`)
   - Domain-specific exceptions
   - Carries validation error messages

### Data Layer (Data Management)

**Location**: `lib/features/whatsapp_link/data/`

**Purpose**: Implements domain repository interfaces with concrete data operations.

**Components**:

1. **Repository Implementation** (`repositories/phone_number_repository_impl.dart`)
   - Implements `PhoneNumberRepository` interface
   - Validates Malaysian phone number format
   - Normalizes to `60XXXXXXXXX` format
   - Throws `InvalidPhoneNumberException` on validation failure

**Validation Rules**:

- Strips all non-digit characters
- Must start with `0` or `60`
- Converts `0` prefix to `60`
- Must start with `601` (Malaysian mobile)
- Must be 11-12 digits total

### Infrastructure Layer (External Services)

**Location**: `lib/features/whatsapp_link/infrastructure/`

**Purpose**: Implements domain service interfaces using third-party packages.

**Components**:

1. **WhatsApp Launcher** (`whatsapp_launcher.dart`)
   - Implements `WhatsAppLauncher` service interface
   - Uses `url_launcher` package
   - Constructs URL: `https://wa.me/{number}`
   - Returns `LaunchResult` (success/failed)

### Presentation Layer (UI)

**Location**: `lib/features/whatsapp_link/presentation/`

**Purpose**: Handles UI and user interactions using BLoC pattern.

**Components**:

1. **State** (`cubit/phone_number_state.dart`)

   - Immutable state class
   - Properties:
     - `input`: Raw user input
     - `phoneNumber`: Validated PhoneNumber entity
     - `isValid`: Boolean validation status
     - `errorMessage`: Optional error text
     - `status`: Launch status (idle/launchRequested)

2. **Cubit** (`cubit/phone_number_cubit.dart`)

   - Manages phone number state
   - Methods:
     - `updateInput(String)`: Validates and updates state
     - `launchWhatsApp()`: Launches WhatsApp with validated number
   - Dependencies:
     - `NormalizeMalaysianNumber` use case
     - `WhatsAppLauncher` service

3. **Page** (`pages/phone_number_page.dart`)
   - Main UI screen
   - Components:
     - TextField with validation error display
     - "Open WhatsApp" button (enabled when valid)
     - Loading indicator during launch
     - Error snackbar on launch failure

### App Layer (Composition Root)

**Location**: `lib/app/` and `lib/main.dart`

**Purpose**: Dependency injection and app initialization.

**Components**:

1. **Main** (`main.dart`)

   - Creates all dependencies
   - Instantiates:
     - `PhoneNumberRepositoryImpl`
     - `NormalizeMalaysianNumber` use case
     - `UrlLauncherWhatsAppLauncher`
   - Passes dependencies to `ChatifyApp`

2. **App Widget** (`app/app.dart`)
   - Provides `PhoneNumberCubit` via `BlocProvider`
   - Configures MaterialApp theme
   - Sets up navigation

## Data Flow

### Input Validation Flow

```
User Input
    ↓
PhoneNumberPage (TextField)
    ↓
PhoneNumberCubit.updateInput()
    ↓
NormalizeMalaysianNumber (use case)
    ↓
PhoneNumberRepositoryImpl.validateAndNormalize()
    ↓
[Valid] → PhoneNumber entity → State (isValid: true)
[Invalid] → InvalidPhoneNumberException → State (errorMessage: "...")
    ↓
PhoneNumberPage (UI updates)
```

### WhatsApp Launch Flow

```
User Tap "Open WhatsApp"
    ↓
PhoneNumberCubit.launchWhatsApp()
    ↓
State (status: launchRequested)
    ↓
UrlLauncherWhatsAppLauncher.launch()
    ↓
url_launcher package
    ↓
[Success] → LaunchResult.success() → State (status: idle)
[Failed] → LaunchResult.failed() → State (errorMessage: "...")
    ↓
PhoneNumberPage (shows loading/error)
```

## State Management (BLoC)

### Why BLoC?

1. **Separation of Business Logic**: Logic is separate from UI
2. **Testability**: Easy to test without UI dependencies
3. **Reusability**: Cubit can be reused across different UIs
4. **Predictability**: Unidirectional data flow
5. **Reactive**: UI automatically updates on state changes

### BLoC Pattern in Chatify

- **Cubit** (simplified BLoC): `PhoneNumberCubit`

  - Manages state transitions
  - Exposes methods (not events) for simplicity
  - Emits new states on changes

- **State**: `PhoneNumberState`

  - Immutable
  - Contains all UI-relevant data
  - Uses `copyWith` for updates

- **UI**: `PhoneNumberPage`
  - `BlocBuilder`: Rebuilds on state changes
  - `BlocConsumer`: Listens for side effects (launch, errors)
  - `BlocProvider`: Provides cubit to widget tree

## Dependency Injection

### Manual DI (Current Implementation)

Dependencies are created in `main.dart` and passed down:

```dart
void main() {
  // Create dependencies
  final repository = PhoneNumberRepositoryImpl();
  final useCase = NormalizeMalaysianNumber(repository);
  final launcher = UrlLauncherWhatsAppLauncher();

  // Inject into app
  runApp(ChatifyApp(
    normalizeMalaysianNumber: useCase,
    whatsAppLauncher: launcher,
  ));
}
```

**Benefits**:

- Simple and explicit
- No additional dependencies
- Easy to understand
- Full control over object lifecycle

**Future Enhancement**:
Could use `get_it` or `injectable` for larger apps.

## Testing Strategy

### Unit Tests (Domain Layer)

- Test use cases in isolation
- Mock repositories
- Test validation rules

### Widget Tests (Presentation Layer)

- Test UI behavior
- Mock cubits
- Verify user interactions

### Integration Tests

- Test complete flows
- Real dependencies
- End-to-end scenarios

## Error Handling

### Domain Exceptions

- `InvalidPhoneNumberException`: Validation errors
- Caught by cubit and converted to state

### Infrastructure Errors

- `LaunchResult.failed()`: Launch failures
- Type-safe error handling
- User-friendly error messages

### UI Error Display

- TextField error text for validation
- SnackBar for launch errors
- Disabled button for invalid input

## Future Enhancements

1. **Dependency Injection**

   - Add `get_it` for service locator pattern
   - Use `injectable` for code generation

2. **Testing**

   - Add unit tests for domain layer
   - Add widget tests for presentation layer
   - Add integration tests

3. **Features**

   - Support for other countries
   - Recent numbers history
   - Contacts integration
   - Custom message support

4. **Architecture**
   - Add use case for launching WhatsApp
   - Add repository for storing recent numbers
   - Add local data source (shared_preferences)

## Conclusion

This implementation demonstrates Clean Architecture principles in a Flutter app:

- Clear separation of concerns
- Testable business logic
- Framework-independent domain layer
- Type-safe error handling
- Reactive UI with BLoC
- Explicit dependency injection

The architecture is scalable and maintainable, making it easy to add new features or change implementations without affecting other layers.
