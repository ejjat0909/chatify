import 'package:flutter/material.dart';

import 'app/app.dart';
import 'features/whatsapp_link/data/repositories/phone_number_repository_impl.dart';
import 'features/whatsapp_link/domain/usecases/normalize_malaysian_number.dart';
import 'features/whatsapp_link/infrastructure/whatsapp_launcher.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final repository = PhoneNumberRepositoryImpl();
  final normalizeMalaysianNumber = NormalizeMalaysianNumber(repository);
  final whatsAppLauncher = UrlLauncherWhatsAppLauncher();

  runApp(
    ChatifyApp(
      normalizeMalaysianNumber: normalizeMalaysianNumber,
      whatsAppLauncher: whatsAppLauncher,
    ),
  );
}
