import 'package:url_launcher/url_launcher.dart';

import '../domain/services/whatsapp_launcher.dart';
import '../domain/value_objects/launch_result.dart';

class UrlLauncherWhatsAppLauncher implements WhatsAppLauncher {
  @override
  Future<LaunchResult> launch({required String number}) async {
    try {
      final uri = Uri.parse('https://wa.me/$number');

      final didLaunch = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!didLaunch) {
        return const LaunchResult.failed('Could not open WhatsApp link.');
      }

      return const LaunchResult.success();
    } catch (e) {
      return LaunchResult.failed('Failed to launch WhatsApp: ${e.toString()}');
    }
  }
}
