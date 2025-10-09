import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glassmorphism/glassmorphism.dart';

import '../cubit/phone_number_cubit.dart';
import '../cubit/phone_number_state.dart';
import '../widgets/glass_snackbar.dart';

class PhoneNumberPage extends StatefulWidget {
  const PhoneNumberPage({super.key});

  @override
  State<PhoneNumberPage> createState() => _PhoneNumberPageState();
}

class _PhoneNumberPageState extends State<PhoneNumberPage> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Chatify'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: GlassmorphicContainer(
                  width: size.width * 0.35,
                  height: size.width * 0.35,
                  borderRadius: size.width,
                  blur: 20,
                  alignment: Alignment.center,
                  border: 1,
                  linearGradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.25),
                      Colors.white.withOpacity(0.05),
                    ],
                  ),
                  borderGradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.6),
                      Colors.white.withOpacity(0.1),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: GlassmorphicContainer(
                  width: size.width * 0.5,
                  height: size.width * 0.5,
                  borderRadius: size.width,
                  blur: 18,
                  alignment: Alignment.center,
                  border: 1,
                  linearGradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      colorScheme.secondary.withOpacity(0.35),
                      Colors.white.withOpacity(0.08),
                    ],
                  ),
                  borderGradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.4),
                      Colors.white.withOpacity(0.1),
                    ],
                  ),
                ),
              ),
              Center(
                child: GlassmorphicContainer(
                  width: size.width > 600 ? 480 : size.width * 0.9,
                  height: size.height * 0.65,
                  borderRadius: 28,
                  blur: 24,
                  border: 1.5,
                  alignment: Alignment.center,
                  linearGradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.28),
                      Colors.white.withOpacity(0.1),
                    ],
                  ),
                  borderGradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.6),
                      Colors.white.withOpacity(0.2),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(28),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Create your WhatsApp link',
                          style: textTheme.headlineSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Enter a Malaysian phone number to quickly launch WhatsApp and start chatting instantly.',
                          style: textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withOpacity(0.75),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                        BlocBuilder<PhoneNumberCubit, PhoneNumberState>(
                          builder: (context, state) {
                            return TextField(
                              controller: _controller,
                              keyboardType: TextInputType.phone,
                              style: textTheme.bodyLarge?.copyWith(
                                color: Colors.white,
                              ),
                              cursorColor: Colors.white70,
                              decoration: InputDecoration(
                                labelText: 'Phone number',
                                labelStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                ),
                                hintText: 'e.g. 013-456 7890',
                                hintStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.6),
                                ),
                                errorText: state.validationError,
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.12),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 20,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  borderSide: BorderSide(
                                    color: Colors.white.withOpacity(0.2),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  borderSide: BorderSide(
                                    color: colorScheme.primary.withOpacity(0.9),
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  borderSide: BorderSide(
                                    color: colorScheme.error,
                                  ),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  borderSide: BorderSide(
                                    color: colorScheme.error,
                                  ),
                                ),
                                suffixIcon: state.input.isNotEmpty
                                    ? IconButton(
                                        icon: const Icon(Icons.clear),
                                        color: Colors.white,
                                        onPressed: () {
                                          _controller.clear();
                                          context
                                              .read<PhoneNumberCubit>()
                                              .updateInput('');
                                        },
                                      )
                                    : null,
                              ),
                              onChanged: context
                                  .read<PhoneNumberCubit>()
                                  .updateInput,
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: BorderSide(
                                color: Colors.white.withOpacity(0.5),
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            onPressed: () async {
                              final clipboardData = await Clipboard.getData(
                                'text/plain',
                              );
                              final clipboardText =
                                  clipboardData?.text?.trim() ?? '';
                              if (clipboardText.isEmpty) {
                                if (!mounted) return;
                                showGlassSnackbar(
                                  context,
                                  message: 'Clipboard is empty.',
                                );
                                return;
                              }

                              final validationError = context
                                  .read<PhoneNumberCubit>()
                                  .validateMalaysianNumber(clipboardText);
                              if (validationError != null) {
                                if (!mounted) return;
                                showGlassSnackbar(
                                  context,
                                  message:
                                      'Phone number from clipboard is invalid. Cannot paste',
                                );
                                return;
                              }

                              _controller.value = TextEditingValue(
                                text: clipboardText,
                                selection: TextSelection.collapsed(
                                  offset: clipboardText.length,
                                ),
                              );
                              context.read<PhoneNumberCubit>().updateInput(
                                clipboardText,
                              );
                            },
                            icon: const Icon(Icons.paste_rounded),
                            label: const Text('Paste from clipboard'),
                          ),
                        ),
                        const SizedBox(height: 16),
                        BlocConsumer<PhoneNumberCubit, PhoneNumberState>(
                          listener: (context, state) {
                            if (state.launchError != null) {
                              showGlassSnackbar(
                                context,
                                message: state.launchError!,
                              );
                            }
                          },
                          builder: (context, state) {
                            if (state.status ==
                                PhoneNumberStatus.launchRequested) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              );
                            }

                            return SizedBox(
                              width: double.infinity,
                              child: FilledButton.icon(
                                style: FilledButton.styleFrom(
                                  backgroundColor: colorScheme.primary
                                      .withOpacity(0.9),
                                  foregroundColor: colorScheme.onPrimary
                                      .withOpacity(0.95),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 18,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                ),
                                onPressed: state.isValid
                                    ? () => context
                                          .read<PhoneNumberCubit>()
                                          .launchWhatsApp()
                                    : null,
                                icon: const Icon(Icons.chat_bubble_outline),
                                label: const Text('Open WhatsApp'),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Opening WhatsApp will happen outside of Chatify.',
                          style: textTheme.bodySmall?.copyWith(
                            color: Colors.white.withOpacity(0.7),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
