import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../features/whatsapp_link/domain/services/whatsapp_launcher.dart';
import '../features/whatsapp_link/domain/usecases/normalize_malaysian_number.dart';
import '../features/whatsapp_link/presentation/cubit/app_version_cubit.dart';
import '../features/whatsapp_link/presentation/cubit/phone_number_cubit.dart';
import '../features/whatsapp_link/presentation/cubit/update_checker_cubit.dart';
import '../features/whatsapp_link/presentation/pages/phone_number_page.dart';

class ChatifyApp extends StatelessWidget {
  const ChatifyApp({
    super.key,
    required this.normalizeMalaysianNumber,
    required this.whatsAppLauncher,
  });

  final NormalizeMalaysianNumber normalizeMalaysianNumber;
  final WhatsAppLauncher whatsAppLauncher;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PhoneNumberCubit>(
          create: (_) => PhoneNumberCubit(
            normalize: normalizeMalaysianNumber,
            launcher: whatsAppLauncher,
          ),
        ),
        BlocProvider<AppVersionCubit>(create: (_) => AppVersionCubit()),
        BlocProvider<UpdateCheckerCubit>(create: (_) => UpdateCheckerCubit()),
      ],
      child: MaterialApp(
        title: 'Chatify',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        ),
        home: const PhoneNumberPage(),
      ),
    );
  }
}
