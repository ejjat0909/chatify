import '../../domain/entities/phone_number.dart';
import '../../domain/exceptions/invalid_phone_number_exception.dart';
import '../../domain/repositories/phone_number_repository.dart';

class PhoneNumberRepositoryImpl implements PhoneNumberRepository {
  @override
  PhoneNumber validateAndNormalize(String input) {
    final digitsOnly = input.replaceAll(RegExp(r'[^0-9]'), '');

    if (digitsOnly.isEmpty) {
      throw InvalidPhoneNumberException('Phone number is required.');
    }

    if (!digitsOnly.startsWith('0') && !digitsOnly.startsWith('60')) {
      throw InvalidPhoneNumberException('Number must start with 0 or 60.');
    }

    var normalized = digitsOnly;
    if (normalized.startsWith('0')) {
      normalized = '6$normalized';
    }

    if (!normalized.startsWith('60')) {
      normalized = '60$normalized';
    }

    if (!normalized.startsWith('601') || normalized.length < 11 || normalized.length > 12) {
      throw InvalidPhoneNumberException('Invalid Malaysian mobile number.');
    }

    return PhoneNumber(rawInput: input, normalized: normalized);
  }
}