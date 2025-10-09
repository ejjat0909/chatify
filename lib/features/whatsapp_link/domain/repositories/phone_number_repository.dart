import '../entities/phone_number.dart';

abstract class PhoneNumberRepository {
  PhoneNumber validateAndNormalize(String input);
}