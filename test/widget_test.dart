import 'package:chatify/app/app.dart';
import 'package:chatify/features/whatsapp_link/data/repositories/phone_number_repository_impl.dart';
import 'package:chatify/features/whatsapp_link/domain/usecases/normalize_malaysian_number.dart';
import 'package:chatify/features/whatsapp_link/infrastructure/whatsapp_launcher.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Chatify app smoke test', (WidgetTester tester) async {
    final repository = PhoneNumberRepositoryImpl();
    final normalizeMalaysianNumber = NormalizeMalaysianNumber(repository);
    final whatsAppLauncher = UrlLauncherWhatsAppLauncher();

    await tester.pumpWidget(
      ChatifyApp(
        normalizeMalaysianNumber: normalizeMalaysianNumber,
        whatsAppLauncher: whatsAppLauncher,
      ),
    );

    expect(find.text('Chatify'), findsOneWidget);
    expect(find.text('Enter Malaysian phone number'), findsOneWidget);
    expect(find.text('Open WhatsApp'), findsOneWidget);
  });
}
