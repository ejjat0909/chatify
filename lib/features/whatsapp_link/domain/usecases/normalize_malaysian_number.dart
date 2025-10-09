import '../entities/phone_number.dart';
import '../repositories/phone_number_repository.dart';

class NormalizeMalaysianNumber {
  const NormalizeMalaysianNumber(this.repository);

  final PhoneNumberRepository repository;

  PhoneNumber call(String input) {
    return repository.validateAndNormalize(input);
  }
}