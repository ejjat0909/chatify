import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../features/whatsapp_link/domain/services/whatsapp_launcher.dart';
import '../features/whatsapp_link/domain/usecases/normalize_malaysian_number.dart';
import '../features/whatsapp_link/presentation/cubit/app_version_cubit.dart';
import '../features/whatsapp_link/presentation/cubit/message_cubit.dart';
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
        BlocProvider<MessageCubit>(create: (_) => MessageCubit()),
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
        home: const _AppInitializer(),
      ),
    );
  }
}

/// Initializes the MessageCubit before rendering PhoneNumberPage
class _AppInitializer extends StatefulWidget {
  const _AppInitializer();

  @override
  State<_AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<_AppInitializer> {
  late Future<void> _initFuture;

  @override
  void initState() {
    super.initState();
    // Initialize MessageCubit before building the page
    _initFuture = context.read<MessageCubit>().initialize();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show loading while initializing
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        // Once initialized, show the main page
        return const PhoneNumberPage();
      },
    );
  }
}
