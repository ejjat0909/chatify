import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/exceptions/invalid_phone_number_exception.dart';
import '../../domain/services/whatsapp_launcher.dart';
import '../../domain/usecases/normalize_malaysian_number.dart';
import 'phone_number_state.dart';

class PhoneNumberCubit extends Cubit<PhoneNumberState> {
  PhoneNumberCubit({
    required NormalizeMalaysianNumber normalize,
    required WhatsAppLauncher launcher,
  }) : _normalize = normalize,
       _launcher = launcher,
       super(PhoneNumberState.initial());

  final NormalizeMalaysianNumber _normalize;
  final WhatsAppLauncher _launcher;

  void updateInput(String input) {
    try {
      final phoneNumber = _normalize(input);
      emit(
        state.copyWith(
          input: input,
          phoneNumber: phoneNumber,
          isValid: true,
          validationError: null,
          launchError: null,
          status: PhoneNumberStatus.idle,
        ),
      );
    } on InvalidPhoneNumberException catch (error) {
      emit(
        state.copyWith(
          input: input,
          phoneNumber: null,
          isValid: false,
          validationError: error.message,
          launchError: null,
          status: PhoneNumberStatus.idle,
        ),
      );
    }
  }

  String? validateMalaysianNumber(String input) {
    try {
      _normalize(input);
      return null;
    } on InvalidPhoneNumberException catch (error) {
      return error.message;
    }
  }

  Future<void> launchWhatsApp() async {
    final normalized = state.phoneNumber?.normalized;
    if (normalized == null) {
      emit(
        state.copyWith(
          launchError: 'Please enter a valid Malaysian number.',
          status: PhoneNumberStatus.idle,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: PhoneNumberStatus.launchRequested,
        launchError: null,
      ),
    );

    final result = await _launcher.launch(number: normalized);
    result.when(
      success: () => emit(
        state.copyWith(status: PhoneNumberStatus.idle, launchError: null),
      ),
      failed: (message) => emit(
        state.copyWith(status: PhoneNumberStatus.idle, launchError: message),
      ),
    );
  }
}
