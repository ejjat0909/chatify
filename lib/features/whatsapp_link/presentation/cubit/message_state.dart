enum MessageStatus { idle }

class MessageState {
  const MessageState({
    this.greetingMessage = '',
    this.arrivalMessage = '',
    this.status = MessageStatus.idle,
  });

  final String greetingMessage;
  final String arrivalMessage;
  final MessageStatus status;

  /// Combine greeting and arrival messages
  String get combinedMessage {
    final parts = <String>[];
    if (greetingMessage.isNotEmpty) parts.add(greetingMessage);
    if (arrivalMessage.isNotEmpty) parts.add(arrivalMessage);
    return parts.join('. ');
  }

  MessageState copyWith({
    String? greetingMessage,
    String? arrivalMessage,
    MessageStatus? status,
  }) {
    return MessageState(
      greetingMessage: greetingMessage ?? this.greetingMessage,
      arrivalMessage: arrivalMessage ?? this.arrivalMessage,
      status: status ?? this.status,
    );
  }

  factory MessageState.initial() {
    return const MessageState();
  }
}
