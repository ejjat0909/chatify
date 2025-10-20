# Pre-filled Message Feature - Usage Guide

## Quick Overview

The feature allows users to compose WhatsApp messages using pre-built buttons organized in two sections:

```
┌─────────────────────────────────────────┐
│   Phone Number Input                    │
├─────────────────────────────────────────┤
│   [Optional Message Display]            │
│   (Auto-updates as buttons are pressed) │
├─────────────────────────────────────────┤
│   🎯 GREETING SECTION                   │
│   ┌───────────────────────────────────┐ │
│   │ Lalamove here                     │ │
│   └───────────────────────────────────┘ │
├─────────────────────────────────────────┤
│   ⏱️ ARRIVAL TIME SECTION                │
│   ┌───────────────────────────────────┐ │
│   │ Arrive in 5 minutes               │ │
│   ├───────────────────────────────────┤ │
│   │ Arrive in 10 minutes              │ │
│   ├───────────────────────────────────┤ │
│   │ Arrive in 15 minutes              │ │
│   ├───────────────────────────────────┤ │
│   │ Arrive in 20 minutes              │ │
│   └───────────────────────────────────┘ │
├─────────────────────────────────────────┤
│   [Paste from Clipboard]                │
├─────────────────────────────────────────┤
│   ✨ Open WhatsApp                       │
└─────────────────────────────────────────┘
```

## Example Scenarios

### Scenario 1: Greeting Only

- **User Action**: Click "Lalamove here"
- **Message Field Shows**: "Lalamove here"
- **WhatsApp Receives**: "Lalamove here"

### Scenario 2: Arrival Time Only

- **User Action**: Click "Arrive in 10 minutes"
- **Message Field Shows**: "Arrive in 10 minutes"
- **WhatsApp Receives**: "Arrive in 10 minutes"

### Scenario 3: Full Message

- **User Action**:
  1. Click "Lalamove here"
  2. Click "Arrive in 10 minutes"
- **Message Field Shows**: "Lalamove here. Arrive in 10 minutes"
- **WhatsApp Receives**: "Lalamove here. Arrive in 10 minutes"

### Scenario 4: Change Arrival Time

- **User Action**:
  1. Click "Arrive in 10 minutes"
  2. Click "Arrive in 15 minutes"
- **Message Field Shows**: "Arrive in 15 minutes" (10 minutes replaced)
- **WhatsApp Receives**: "Arrive in 15 minutes"

## Button Behavior

### Visual Feedback

- **Default State**: Semi-transparent white glass
- **Selected State**: Bright cyan glass with glow
- **Press Animation**: Smooth scale-down effect

### Selection Rules

- **Greeting Section**: Only 1 button available (can be selected/deselected)
- **Arrival Time Section**: Only 1 button can be active at a time
- **Selecting a New Button**: Automatically deselects the previously selected button in same section

## Message Field

- **Type**: Read-only text field
- **Purpose**: Live preview of message to be sent
- **Auto-Update**: Reflects changes immediately when buttons are pressed
- **Text Field Height**: Spans 3 lines for visibility

## Integration with WhatsApp

The pre-filled message is encoded and appended to the WhatsApp URL:

```
https://wa.me/[PHONE_NUMBER]?text=[URL_ENCODED_MESSAGE]
```

This ensures:

- ✅ Message appears in WhatsApp composer
- ✅ User can edit before sending
- ✅ Special characters are safely encoded
- ✅ Works on all platforms (Android, iOS, Web)

## State Management

### MessageCubit Events

```dart
// Update greeting (overrides previous)
context.read<MessageCubit>().updateGreetingMessage('Lalamove here');

// Update arrival time (overrides previous)
context.read<MessageCubit>().updateArrivalMessage('Arrive in 10 minutes');

// Clear individual sections
context.read<MessageCubit>().clearGreetingMessage();
context.read<MessageCubit>().clearArrivalMessage();

// Clear everything
context.read<MessageCubit>().clearAllMessages();
```

### Getting Combined Message

```dart
final message = context.read<MessageCubit>().state.combinedMessage;
// Returns: "Lalamove here. Arrive in 10 minutes"
// Or: "Lalamove here" (if only greeting)
// Or: "" (if nothing selected)
```

## Design Consistency

All new components maintain the existing design language:

| Aspect        | Implementation                                |
| ------------- | --------------------------------------------- |
| Glass Effect  | Glassmorphism with blur 18-20                 |
| Border        | 1.1-1.2px with gradient                       |
| Colors        | Cyan (#43D9FF) when selected, white otherwise |
| Shadows       | Dual shadow: cyan glow + black shadow         |
| Animation     | Scale 0.96-1.0 on press (180ms)               |
| Border Radius | 16px for buttons, 20px for fields             |
| Padding       | 22-24px horizontal, 20px vertical             |

## Technical Implementation

### Files Hierarchy

```
lib/features/whatsapp_link/
├── presentation/
│   ├── cubit/
│   │   ├── message_cubit.dart          (NEW)
│   │   ├── message_state.dart          (NEW)
│   │   ├── phone_number_cubit.dart     (MODIFIED)
│   │   └── ...
│   ├── widgets/
│   │   ├── pre_filled_message_field.dart    (NEW)
│   │   ├── greeting_section.dart            (NEW)
│   │   ├── arrival_time_section.dart        (NEW)
│   │   └── ...
│   └── pages/
│       └── phone_number_page.dart      (MODIFIED)
├── domain/
│   └── services/
│       └── whatsapp_launcher.dart      (MODIFIED)
└── infrastructure/
    └── whatsapp_launcher.dart          (MODIFIED)
```

## Testing the Feature

1. **Start App**: `flutter run`
2. **Navigate to WhatsApp Launch**: Load the phone number page
3. **Test Greeting**:

   - Click "Lalamove here"
   - Verify message field shows "Lalamove here"
   - Verify cyan highlight on button

4. **Test Arrival Time**:

   - Click "Arrive in 10 minutes"
   - Verify message field shows "Arrive in 10 minutes"
   - Click "Arrive in 15 minutes"
   - Verify message updated and previous selection cleared

5. **Test Combined**:

   - Click "Lalamove here"
   - Click "Arrive in 10 minutes"
   - Verify message shows "Lalamove here. Arrive in 10 minutes"

6. **Test WhatsApp Launch**:
   - Enter valid Malaysian phone number
   - Select both buttons
   - Click "Open WhatsApp"
   - Verify WhatsApp opens with pre-filled message

## Future Enhancements

Possible extensions to this feature:

- Custom message templates
- Frequency-based message suggestions
- Message history/favorites
- Multi-language support
- Emoji support in messages
- Message preview with actual WhatsApp formatting
