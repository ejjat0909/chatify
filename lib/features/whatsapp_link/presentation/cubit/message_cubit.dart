import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'message_state.dart';

class MessageCubit extends Cubit<MessageState> {
  MessageCubit({SharedPreferences? prefs})
    : _prefs = prefs,
      super(MessageState.initial());

  final SharedPreferences? _prefs;

  static const String _greetingKey = 'greeting_message';
  static const String _arrivalKey = 'arrival_message';
  static const String _defaultGreeting = 'Lalamove here';

  /// Initialize by loading messages from shared preferences
  Future<void> initialize() async {
    try {
      final prefs = _prefs ?? await SharedPreferences.getInstance();

      // Load greeting message
      String greetingMessage = prefs.getString(_greetingKey) ?? '';

      // If not found, set default and save
      if (greetingMessage.isEmpty) {
        await prefs.setString(_greetingKey, _defaultGreeting);
        greetingMessage = _defaultGreeting;
      }

      // Load arrival message
      String arrivalMessage = prefs.getString(_arrivalKey) ?? '';

      emit(
        MessageState(
          greetingMessage: greetingMessage,
          arrivalMessage: arrivalMessage,
        ),
      );
    } catch (e) {
      // Fallback to default state
      emit(MessageState(greetingMessage: _defaultGreeting));
    }
  }

  Future<void> updateGreetingMessage(String message) async {
    try {
      final prefs = _prefs ?? await SharedPreferences.getInstance();
      await prefs.setString(_greetingKey, message);
      emit(state.copyWith(greetingMessage: message));
    } catch (e) {
      // Emit state change without saving if storage fails
      emit(state.copyWith(greetingMessage: message));
    }
  }

  Future<void> updateArrivalMessage(String message) async {
    try {
      final prefs = _prefs ?? await SharedPreferences.getInstance();
      await prefs.setString(_arrivalKey, message);
      emit(state.copyWith(arrivalMessage: message));
    } catch (e) {
      // Emit state change without saving if storage fails
      emit(state.copyWith(arrivalMessage: message));
    }
  }

  Future<void> clearGreetingMessage() async {
    try {
      final prefs = _prefs ?? await SharedPreferences.getInstance();
      await prefs.remove(_greetingKey);
      emit(state.copyWith(greetingMessage: ''));
    } catch (e) {
      emit(state.copyWith(greetingMessage: ''));
    }
  }

  Future<void> clearArrivalMessage() async {
    try {
      final prefs = _prefs ?? await SharedPreferences.getInstance();
      await prefs.remove(_arrivalKey);
      emit(state.copyWith(arrivalMessage: ''));
    } catch (e) {
      emit(state.copyWith(arrivalMessage: ''));
    }
  }

  Future<void> clearAllMessages() async {
    try {
      final prefs = _prefs ?? await SharedPreferences.getInstance();
      await prefs.remove(_greetingKey);
      await prefs.remove(_arrivalKey);
      emit(MessageState.initial());
    } catch (e) {
      emit(MessageState.initial());
    }
  }
}
