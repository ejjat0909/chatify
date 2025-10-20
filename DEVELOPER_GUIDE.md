# Pre-filled Message Feature - Developer Guide

## Architecture Overview

### Clean Architecture Layers

```
┌─────────────────────────────────────┐
│  PRESENTATION LAYER                 │
│  (phone_number_page.dart)           │
│  - UI Components & User Interaction │
└────────────────────┬────────────────┘
                     │
        ┌────────────┴────────────┐
        │                         │
┌───────▼──────────────┐  ┌──────▼──────────────┐
│ CUBITS               │  │ WIDGETS            │
│ - MessageCubit       │  │ - GreetingSection  │
│ - PhoneNumberCubit   │  │ - ArrivalTimeSeq   │
│ - (others)           │  │ - MessageField     │
└───────┬──────────────┘  └─────────────────────┘
        │
┌───────▼─────────────────────────────┐
│  DOMAIN LAYER                       │
│  (Services & Use Cases)             │
│  - WhatsAppLauncher (abstract)      │
└────────────────────┬────────────────┘
                     │
┌────────────────────▼────────────────┐
│  INFRASTRUCTURE LAYER               │
│  (Implementations)                  │
│  - UrlLauncherWhatsAppLauncher      │
└─────────────────────────────────────┘
```

## Key Components

### 1. MessageState (State Management)

```dart
class MessageState {
  final String greetingMessage;      // "Lalamove here" or ""
  final String arrivalMessage;       // "Arrive in X minutes" or ""

  // Computed property for combined message
  String get combinedMessage {
    // Returns "Lalamove here. Arrive in 10 minutes"
    // Or "Lalamove here" if only greeting
    // Or "" if both empty
  }
}
```

**Key Feature**: The `combinedMessage` getter intelligently combines both messages with proper formatting.

### 2. MessageCubit (Business Logic)

```dart
class MessageCubit extends Cubit<MessageState> {
  // Override entire greeting (button press)
  void updateGreetingMessage(String message);

  // Override entire arrival message (button press)
  void updateArrivalMessage(String message);

  // Clear individual sections
  void clearGreetingMessage();
  void clearArrivalMessage();

  // Reset everything
  void clearAllMessages();
}
```

**Design Pattern**: Single responsibility - manages message state only.

### 3. Widget Components

#### PreFilledMessageField

```dart
class PreFilledMessageField extends StatefulWidget {
  // Read-only display of combined message
  // Uses BlocListener to auto-update on message changes
  // Styled with glassmorphism
}
```

**Usage**:

```dart
PreFilledMessageField(
  colorScheme: colorScheme,
  textTheme: textTheme,
)
```

#### GreetingSection

```dart
class GreetingSection extends StatelessWidget {
  // Contains greeting button(s)
  // Uses BlocBuilder to track selection state
  // Only 1 button: "Lalamove here"
}
```

**Extensibility**: Can easily add more greeting options by modifying the widget.

#### ArrivalTimeSection

```dart
class ArrivalTimeSection extends StatelessWidget {
  static const List<String> arrivalTimes = [
    'Arrive in 5 minutes',
    'Arrive in 10 minutes',
    'Arrive in 15 minutes',
    'Arrive in 20 minutes',
  ];

  // Multiple buttons, only 1 selected at a time
  // Uses BlocBuilder for reactive selection
}
```

**Extension Pattern**: Add new times by updating the `arrivalTimes` list.

### 4. WhatsApp Integration

#### Domain Service (Abstract)

```dart
abstract class WhatsAppLauncher {
  // Message parameter is optional
  Future<LaunchResult> launch({
    required String number,
    String? message,
  });
}
```

#### Infrastructure Implementation

```dart
class UrlLauncherWhatsAppLauncher implements WhatsAppLauncher {
  Future<LaunchResult> launch({
    required String number,
    String? message,
  }) async {
    // Constructs: https://wa.me/60123456789?text=Lalamove%20here
    final uri = message != null && message.isNotEmpty
        ? Uri.parse('https://wa.me/$number?text=${Uri.encodeComponent(message)}')
        : Uri.parse('https://wa.me/$number');

    // Launch WhatsApp with pre-filled message
    return launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
```

**Safe Encoding**: Uses `Uri.encodeComponent()` for proper URL encoding.

### 5. Phone Number Cubit (Updated)

```dart
class PhoneNumberCubit extends Cubit<PhoneNumberState> {
  // Now accepts optional message parameter
  Future<void> launchWhatsApp({String? message}) async {
    // Passes message to WhatsApp launcher
    final result = await _launcher.launch(
      number: normalized,
      message: message,  // ← NEW
    );
  }
}
```

## State Flow Diagram

```
User Action (Button Press)
         ↓
    MessageCubit
  (updateGreetingMessage or
   updateArrivalMessage)
         ↓
   MessageState Updated
         ↓
    BlocBuilder/Listener
    (in widgets)
         ↓
   PreFilledMessageField
   Auto-updates display
         ↓
User sees combined message
```

## Usage Flow in Code

```dart
// 1. Wrap page with MessageCubit provider
BlocProvider(
  create: (context) => MessageCubit(),
  child: PhoneNumberPage(),
)

// 2. Greeting button press
GestureDetector(
  onTap: () {
    context.read<MessageCubit>().updateGreetingMessage('Lalamove here');
  },
)

// 3. Message field auto-updates
BlocListener<MessageCubit, MessageState>(
  listener: (context, state) {
    _messageController.text = state.combinedMessage;
  },
)

// 4. Launch WhatsApp with message
context.read<MessageCubit>().state.combinedMessage;
// Pass to: phoneNumberCubit.launchWhatsApp(message: ...)
```

## How to Extend

### Add New Greeting Options

**File**: `lib/features/whatsapp_link/presentation/widgets/greeting_section.dart`

```dart
// Change from 1 button to multiple
class GreetingSection extends StatelessWidget {
  static const Map<String, String> greetings = {
    'lalamove': 'Lalamove here',
    'grab': 'Grab here',
    'other': 'Some other message',
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final greeting in greetings.values)
          _GreetingButton(
            label: greeting,
            isSelected: state.greetingMessage == greeting,
            onPressed: () {
              context.read<MessageCubit>().updateGreetingMessage(greeting);
            },
          ),
      ],
    );
  }
}
```

### Add New Arrival Time Options

**File**: `lib/features/whatsapp_link/presentation/widgets/arrival_time_section.dart`

```dart
static const List<String> arrivalTimes = [
  'Arrive in 5 minutes',
  'Arrive in 10 minutes',
  'Arrive in 15 minutes',
  'Arrive in 20 minutes',
  'Arrive in 30 minutes',  // ← NEW
  'Arriving now',           // ← NEW
];
```

### Add Custom Message Formatting

**File**: `lib/features/whatsapp_link/presentation/cubit/message_state.dart`

```dart
String get customFormattedMessage {
  final parts = <String>[];
  if (greetingMessage.isNotEmpty) {
    parts.add('📍 $greetingMessage');  // Add emoji
  }
  if (arrivalMessage.isNotEmpty) {
    parts.add('⏱️ $arrivalMessage');
  }
  return parts.join('\n\n');  // Use newline separator
}
```

### Add Clear Buttons

**File**: `lib/features/whatsapp_link/presentation/pages/phone_number_page.dart`

```dart
// Add clear button in UI
IconButton(
  icon: Icon(Icons.clear),
  onPressed: () {
    context.read<MessageCubit>().clearAllMessages();
  },
)
```

## Testing Considerations

### Unit Tests for MessageCubit

```dart
test('updateGreetingMessage should update state', () {
  final cubit = MessageCubit();
  cubit.updateGreetingMessage('Lalamove here');

  expect(cubit.state.greetingMessage, 'Lalamove here');
  expect(cubit.state.combinedMessage, 'Lalamove here');
});

test('combinedMessage should join both messages', () {
  final cubit = MessageCubit();
  cubit.updateGreetingMessage('Lalamove here');
  cubit.updateArrivalMessage('Arrive in 10 minutes');

  expect(
    cubit.state.combinedMessage,
    'Lalamove here. Arrive in 10 minutes',
  );
});
```

### Widget Tests

```dart
testWidgets('GreetingSection shows button', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: BlocProvider(
        create: (_) => MessageCubit(),
        child: GreetingSection(textTheme: ...),
      ),
    ),
  );

  expect(find.text('Lalamove here'), findsOneWidget);
});

testWidgets('Button press updates message', (tester) async {
  // Test button interaction
  await tester.tap(find.text('Lalamove here'));
  await tester.pump();

  // Verify state changed
  expect(
    find.widgetWithText(Text, 'Lalamove here'),
    findsWidgets,
  );
});
```

## Performance Considerations

1. **BlocListener vs BlocBuilder**:

   - Use `BlocListener` for message field (one-way data flow)
   - Use `BlocBuilder` for button selection state

2. **Message String Concatenation**:

   - Uses immutable strings (no performance issues)
   - Computed getter (re-calculates on each access)
   - Consider caching if performance critical

3. **Widget Rebuilds**:
   - Only buttons and message field rebuild on state change
   - Phone number input unaffected by message state

## Common Pitfalls

❌ **Don't**: Store message in both cubit and widget state
✅ **Do**: Single source of truth in MessageCubit

❌ **Don't**: Mutate button lists directly
✅ **Do**: Update via cubit methods

❌ **Don't**: Create MessageCubit inside button callback
✅ **Do**: Provide once at page level

## File Sizes & Performance

| File                          | Lines    | Size        | Purpose           |
| ----------------------------- | -------- | ----------- | ----------------- |
| message_state.dart            | ~40      | ~1.2KB      | State class       |
| message_cubit.dart            | ~30      | ~0.9KB      | Business logic    |
| pre_filled_message_field.dart | ~80      | ~2.3KB      | Read-only field   |
| greeting_section.dart         | ~140     | ~4.2KB      | 1 greeting button |
| arrival_time_section.dart     | ~170     | ~5.1KB      | 4 arrival buttons |
| **Total NEW Code**            | **~460** | **~13.7KB** | Clean & efficient |

## Integration Checklist

- [x] MessageCubit created
- [x] MessageState created
- [x] PreFilledMessageField widget created
- [x] GreetingSection widget created
- [x] ArrivalTimeSection widget created
- [x] WhatsAppLauncher interface updated
- [x] WhatsAppLauncher implementation updated
- [x] PhoneNumberCubit updated
- [x] PhoneNumberPage updated with BlocProvider
- [x] Code compiles without errors
- [x] Maintains glassmorphism design
- [x] All imports added
