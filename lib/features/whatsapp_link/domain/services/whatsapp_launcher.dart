import '../value_objects/launch_result.dart';

abstract class WhatsAppLauncher {
  Future<LaunchResult> launch({required String number});
}
