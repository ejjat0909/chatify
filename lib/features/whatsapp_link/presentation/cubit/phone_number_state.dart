import '../../domain/entities/phone_number.dart';

enum PhoneNumberStatus { idle, launchRequested }

class PhoneNumberState {
  const PhoneNumberState({
    required this.input,
    required this.phoneNumber,
    required this.isValid,
    this.validationError,
    this.launchError,
    this.status = PhoneNumberStatus.idle,
  });

  final String input;
  final PhoneNumber? phoneNumber;
  final bool isValid;
  final String? validationError;
  final String? launchError;
  final PhoneNumberStatus status;

  PhoneNumberState copyWith({
    String? input,
    PhoneNumber? phoneNumber,
    bool? isValid,
    String? validationError,
    String? launchError,
    PhoneNumberStatus? status,
  }) {
    return PhoneNumberState(
      input: input ?? this.input,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isValid: isValid ?? this.isValid,
      validationError: validationError,
      launchError: launchError,
      status: status ?? this.status,
    );
  }

  factory PhoneNumberState.initial() {
    return const PhoneNumberState(input: '', phoneNumber: null, isValid: false);
  }
}
