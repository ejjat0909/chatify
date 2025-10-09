class InvalidPhoneNumberException implements Exception {
  InvalidPhoneNumberException(this.message);

  final String message;

  @override
  String toString() => 'InvalidPhoneNumberException: $message';
}