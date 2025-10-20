import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:url_launcher/url_launcher.dart';

import '../cubit/app_version_cubit.dart';
import '../cubit/app_version_state.dart';
import '../cubit/phone_number_cubit.dart';
import '../cubit/phone_number_state.dart';
import '../cubit/update_checker_cubit.dart';
import '../cubit/update_checker_state.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<AppVersionCubit>().loadVersion();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _checkForUpdate() async {
    final appVersionState = context.read<AppVersionCubit>().state;
    if (appVersionState.status == AppVersionStatus.success) {
      final currentVersion = appVersionState.version.split(' ')[0];
      if (!mounted) return;
      context.read<UpdateCheckerCubit>().checkForUpdate(currentVersion);
    }
  }

  void _showUpdateDialog(String url, String newVersion) {
    final appVersionState = context.read<AppVersionCubit>().state;
    final currentVersion = appVersionState.version.split(' ')[0];

    showDialog(
      context: context,
      builder: (context) => _GlassDialog(
        title: 'Update Available',
        content:
            'A new version ($newVersion) is available!\n\nCurrent: $currentVersion',
        actions: [
          _GlassDialogButton(
            label: 'Later',
            isPrimary: false,
            onPressed: () => Navigator.of(context).pop(),
          ),
          _GlassDialogButton(
            label: 'Update Now',
            isPrimary: true,
            onPressed: () {
              Navigator.of(context).pop();
              launchUrl(Uri.parse(url));
            },
          ),
        ],
      ),
    );
  }

  void _showNoUpdateDialog() {
    final appVersionState = context.read<AppVersionCubit>().state;
    final currentVersion = appVersionState.version.split(' ')[0];

    showDialog(
      context: context,
      builder: (context) => _GlassDialog(
        title: 'You\'re Up to Date',
        content: 'You are already using the latest version ($currentVersion).',
        actions: [
          _GlassDialogButton(
            label: 'OK',
            isPrimary: true,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  void _showUpdateErrorDialog(String error) {
    showDialog(
      context: context,
      builder: (context) => _GlassDialog(
        title: 'Update Check Failed',
        content: 'Could not check for updates.\n\nError: $error',
        actions: [
          _GlassDialogButton(
            label: 'OK',
            isPrimary: true,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return BlocListener<UpdateCheckerCubit, UpdateCheckerState>(
      listener: (context, state) {
        if (state is UpdateCheckerSuccess) {
          _showUpdateDialog(state.updateUrl, state.newVersion);
        } else if (state is UpdateCheckerNoUpdate) {
          _showNoUpdateDialog();
        } else if (state is UpdateCheckerFailure) {
          _showUpdateErrorDialog(state.error);
        }
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: _GlassAppBarTitle(
            colorScheme: colorScheme,
            textTheme: textTheme,
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          systemOverlayStyle: SystemUiOverlayStyle.light,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: _GlassIconButton(
                icon: Icons.download_rounded,
                onPressed: _checkForUpdate,
                tooltip: 'Check for updates',
              ),
            ),
          ],
        ),
        body: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF02111B), Color(0xFF062C3F), Color(0xFF0C4C6D)],
            ),
          ),
          child: SafeArea(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: GlassmorphicContainer(
                    width: size.width * 0.36,
                    height: size.width * 0.36,
                    borderRadius: size.width,
                    blur: 28,
                    alignment: Alignment.center,
                    border: 1,
                    linearGradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFF74EBD5).withOpacity(0.35),
                        Colors.white.withOpacity(0.08),
                      ],
                      stops: const [0, 1],
                    ),
                    borderGradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(0.65),
                        Colors.white.withOpacity(0.12),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: GlassmorphicContainer(
                    width: size.width * 0.58,
                    height: size.width * 0.58,
                    borderRadius: size.width,
                    blur: 25,
                    alignment: Alignment.center,
                    border: 1,
                    linearGradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFFACB6E5).withOpacity(0.33),
                        Colors.white.withOpacity(0.06),
                      ],
                      stops: const [0, 1],
                    ),
                    borderGradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(0.52),
                        Colors.white.withOpacity(0.1),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: size.height * 0.04,
                  left: size.width * 0.12,
                  child: Container(
                    width: size.width * 0.18,
                    height: size.width * 0.18,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          const Color(0xFF98F3FF).withOpacity(0.27),
                          Colors.transparent,
                        ],
                        stops: const [0, 1],
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF43D9FF).withOpacity(0.38),
                          blurRadius: 72,
                          spreadRadius: 8,
                          offset: const Offset(-20, 30),
                        ),
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          blurRadius: 64,
                          spreadRadius: 6,
                          offset: const Offset(20, 34),
                        ),
                      ],
                    ),
                    child: GlassmorphicContainer(
                      width: size.width > 600 ? 520 : size.width * 0.92,
                      height: size.height * 0.7,
                      borderRadius: 34,
                      blur: 30,
                      border: 1.6,
                      alignment: Alignment.center,
                      linearGradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withOpacity(0.55),
                          Colors.white.withOpacity(0.18),
                          Colors.white.withOpacity(0.05),
                        ],
                        stops: const [0, 0.5, 1],
                      ),
                      borderGradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withOpacity(0.85),
                          Colors.white.withOpacity(0.3),
                        ],
                      ),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            top: -70,
                            right: -50,
                            child: Container(
                              width: size.width * 0.42,
                              height: size.width * 0.42,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(size.width),
                                gradient: RadialGradient(
                                  colors: [
                                    Colors.white.withOpacity(0.65),
                                    Colors.white.withOpacity(0.05),
                                  ],
                                  stops: const [0, 1],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: -90,
                            left: -60,
                            child: Container(
                              width: size.width * 0.55,
                              height: size.width * 0.55,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(size.width),
                                gradient: RadialGradient(
                                  colors: [
                                    const Color(0xFF6EC3F4).withOpacity(0.48),
                                    Colors.transparent,
                                  ],
                                  stops: const [0, 1],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 36,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 18,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(50),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.2),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 10,
                                        height: 10,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF9DF6FF),
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        'WhatsApp quick launch',
                                        style: textTheme.labelLarge?.copyWith(
                                          color: Colors.white.withOpacity(0.78),
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 26),
                                Text(
                                  'Create your WhatsApp link',
                                  style: textTheme.headlineSmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.2,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Drop in a Malaysian phone number and we\'ll launch WhatsApp in a snap — fluid, fast, and polished.',
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: Colors.white.withOpacity(0.72),
                                    height: 1.5,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 36),
                                BlocBuilder<PhoneNumberCubit, PhoneNumberState>(
                                  builder: (context, state) {
                                    return TextField(
                                      controller: _controller,
                                      keyboardType: TextInputType.phone,
                                      style: textTheme.titleMedium?.copyWith(
                                        color: Colors.white,
                                      ),
                                      cursorColor: Colors.white70,
                                      decoration: InputDecoration(
                                        labelText: 'Phone number',
                                        labelStyle: TextStyle(
                                          color: Colors.white.withOpacity(0.82),
                                        ),
                                        hintText: 'e.g. 013-456 7890',
                                        hintStyle: TextStyle(
                                          color: Colors.white.withOpacity(0.55),
                                        ),
                                        errorText: state.validationError,
                                        filled: true,
                                        fillColor: Colors.white.withOpacity(
                                          0.12,
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              horizontal: 22,
                                              vertical: 20,
                                            ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                          borderSide: BorderSide(
                                            color: Colors.white.withOpacity(
                                              0.18,
                                            ),
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                          borderSide: BorderSide(
                                            color: colorScheme.primary
                                                .withOpacity(0.85),
                                          ),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                          borderSide: BorderSide(
                                            color: colorScheme.error,
                                          ),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
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
                                const SizedBox(height: 22),
                                SizedBox(
                                  width: double.infinity,
                                  child: OutlinedButton.icon(
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      side: BorderSide(
                                        color: Colors.white.withOpacity(0.4),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                        horizontal: 16,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    onPressed: () async {
                                      final clipboardData =
                                          await Clipboard.getData('text/plain');
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
                                          .validateMalaysianNumber(
                                            clipboardText,
                                          );
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
                                      context
                                          .read<PhoneNumberCubit>()
                                          .updateInput(clipboardText);
                                    },
                                    icon: const Icon(Icons.paste_rounded),
                                    label: const Text(
                                      'Paste the number from clipboard',
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 18),
                                BlocConsumer<
                                  PhoneNumberCubit,
                                  PhoneNumberState
                                >(
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
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Colors.white,
                                              ),
                                        ),
                                      );
                                    }

                                    return _GlassLiquidButton(
                                      enabled: state.isValid,
                                      onPressed: state.isValid
                                          ? () => context
                                                .read<PhoneNumberCubit>()
                                                .launchWhatsApp()
                                          : null,
                                      colorScheme: colorScheme,
                                      textTheme: textTheme,
                                    );
                                  },
                                ),
                                const SizedBox(height: 18),
                                Text(
                                  'Opening WhatsApp will happen outside of Chatify.',
                                  style: textTheme.bodySmall?.copyWith(
                                    color: Colors.white.withOpacity(0.72),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 5.0,
                  left: 0.0,
                  right: 0.0,
                  child: SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: BlocBuilder<AppVersionCubit, AppVersionState>(
                            builder: (context, state) {
                              final display = switch (state.status) {
                                AppVersionStatus.success => state.version,
                                AppVersionStatus.failure => 'Unavailable',
                                _ => '...',
                              };
                              return Text('Chatify v$display');
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GlassIconButton extends StatefulWidget {
  const _GlassIconButton({
    required this.icon,
    required this.onPressed,
    this.tooltip,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final String? tooltip;

  @override
  State<_GlassIconButton> createState() => _GlassIconButtonState();
}

class _GlassIconButtonState extends State<_GlassIconButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip ?? '',
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          widget.onPressed();
        },
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedScale(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          scale: _isPressed ? 0.92 : 1,
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.cyan.withOpacity(0.3),
                  blurRadius: 16,
                  spreadRadius: 2,
                  offset: const Offset(-4, 8),
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 12,
                  spreadRadius: 1,
                  offset: const Offset(4, 6),
                ),
              ],
            ),
            child: GlassmorphicContainer(
              width: 44,
              height: 44,
              borderRadius: 12,
              blur: 20,
              border: 1.2,
              alignment: Alignment.center,
              linearGradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(_isPressed ? 0.35 : 0.45),
                  Colors.cyan.withOpacity(0.08),
                  Colors.white.withOpacity(_isPressed ? 0.05 : 0.08),
                ],
              ),
              borderGradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.7),
                  Colors.white.withOpacity(0.2),
                ],
              ),
              child: Icon(
                widget.icon,
                color: Colors.white.withOpacity(0.9),
                size: 22,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GlassDialog extends StatelessWidget {
  const _GlassDialog({
    required this.title,
    required this.content,
    required this.actions,
  });

  final String title;
  final String content;
  final List<_GlassDialogButton> actions;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 340),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: colorScheme.primary.withOpacity(0.35),
              blurRadius: 40,
              spreadRadius: 4,
              offset: const Offset(-12, 20),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 32,
              spreadRadius: 2,
              offset: const Offset(12, 24),
            ),
          ],
        ),
        child: GlassmorphicContainer(
          width: double.infinity,
          height: 240,
          borderRadius: 28,
          blur: 28,
          border: 1.4,
          alignment: Alignment.center,
          linearGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(0.52),
              colorScheme.primary.withOpacity(0.1),
              Colors.white.withOpacity(0.08),
            ],
            stops: const [0, 0.5, 1],
          ),
          borderGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(0.8),
              Colors.white.withOpacity(0.25),
            ],
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: -20,
                right: -16,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(80),
                    gradient: RadialGradient(
                      colors: [
                        Colors.white.withOpacity(0.6),
                        Colors.white.withOpacity(0.05),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: -24,
                left: -20,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    gradient: RadialGradient(
                      colors: [
                        colorScheme.primary.withOpacity(0.4),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: textTheme.titleLarge?.copyWith(
                        color: Colors.white.withOpacity(0.95),
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      content,
                      style: textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withOpacity(0.8),
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 28),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (int i = 0; i < actions.length; i++) ...[
                          Expanded(child: actions[i]),
                          if (i < actions.length - 1) const SizedBox(width: 12),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GlassDialogButton extends StatefulWidget {
  const _GlassDialogButton({
    required this.label,
    required this.onPressed,
    this.isPrimary = false,
  });

  final String label;
  final VoidCallback onPressed;
  final bool isPrimary;

  @override
  State<_GlassDialogButton> createState() => _GlassDialogButtonState();
}

class _GlassDialogButtonState extends State<_GlassDialogButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        scale: _isPressed ? 0.96 : 1,
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: widget.isPrimary
                    ? Colors.cyan.withOpacity(0.3)
                    : Colors.white.withOpacity(0.1),
                blurRadius: 12,
                spreadRadius: 1,
                offset: const Offset(-2, 6),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 10,
                spreadRadius: 0.5,
                offset: const Offset(2, 4),
              ),
            ],
          ),
          child: GlassmorphicContainer(
            width: double.infinity,
            height: 44,
            borderRadius: 14,
            blur: 18,
            border: 1.1,
            alignment: Alignment.center,
            linearGradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: widget.isPrimary
                  ? [
                      Colors.cyan.withOpacity(_isPressed ? 0.45 : 0.55),
                      Colors.cyan.withOpacity(0.15),
                      Colors.white.withOpacity(0.08),
                    ]
                  : [
                      Colors.white.withOpacity(_isPressed ? 0.35 : 0.45),
                      Colors.white.withOpacity(0.1),
                      Colors.white.withOpacity(0.04),
                    ],
            ),
            borderGradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: widget.isPrimary
                  ? [Colors.cyan.withOpacity(0.8), Colors.cyan.withOpacity(0.3)]
                  : [
                      Colors.white.withOpacity(0.7),
                      Colors.white.withOpacity(0.15),
                    ],
            ),
            child: Text(
              widget.label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontWeight: FontWeight.w600,
                fontSize: 14,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GlassAppBarTitle extends StatelessWidget {
  const _GlassAppBarTitle({required this.colorScheme, required this.textTheme});

  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    final titleStyle = textTheme.titleLarge?.copyWith(
      color: Colors.white.withOpacity(0.92),
      fontWeight: FontWeight.w600,
      letterSpacing: 0.6,
    );

    return GlassmorphicContainer(
      width: 150,
      height: 44,
      borderRadius: 28,
      blur: 24,
      border: 1,
      alignment: Alignment.center,
      linearGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withOpacity(0.45),
          colorScheme.primary.withOpacity(0.12),
          Colors.white.withOpacity(0.04),
        ],
        stops: const [0, 0.55, 1],
      ),
      borderGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withOpacity(0.75),
          Colors.white.withOpacity(0.18),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: -10,
            right: -8,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(60),
                gradient: RadialGradient(
                  colors: [
                    Colors.white.withOpacity(0.7),
                    Colors.white.withOpacity(0.05),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -10,
            left: -12,
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(60),
                gradient: RadialGradient(
                  colors: [
                    colorScheme.primary.withOpacity(0.45),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Center(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.18),
                    Colors.white.withOpacity(0.02),
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 8,
                ),
                child: Text('Chatify', style: titleStyle),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlassLiquidButton extends StatefulWidget {
  const _GlassLiquidButton({
    required this.enabled,
    required this.onPressed,
    required this.colorScheme,
    required this.textTheme,
  });

  final bool enabled;
  final VoidCallback? onPressed;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  State<_GlassLiquidButton> createState() => _GlassLiquidButtonState();
}

class _GlassLiquidButtonState extends State<_GlassLiquidButton> {
  bool _isPressed = false;

  void _setPressed(bool value) {
    if (_isPressed != value) {
      setState(() => _isPressed = value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textColor = Colors.white.withOpacity(widget.enabled ? 0.96 : 0.55);
    final textStyle = widget.textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.w600,
      letterSpacing: 0.3,
      color: textColor,
    );

    return Semantics(
      button: true,
      enabled: widget.enabled,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: widget.enabled ? 1 : 0.55,
        child: AnimatedScale(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          scale: _isPressed ? 0.97 : 1,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: widget.enabled ? (_) => _setPressed(true) : null,
            onTapUp: widget.enabled ? (_) => _setPressed(false) : null,
            onTapCancel: widget.enabled ? () => _setPressed(false) : null,
            onTap: widget.enabled ? widget.onPressed : null,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  top: -32,
                  right: -28,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: _isPressed ? 0.55 : 1,
                    child: Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(120),
                        gradient: RadialGradient(
                          colors: [
                            Colors.white.withOpacity(0.65),
                            Colors.white.withOpacity(0.08),
                          ],
                          stops: const [0, 1],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -36,
                  left: -26,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: _isPressed ? 0.45 : 0.85,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(140),
                        gradient: RadialGradient(
                          colors: [
                            widget.colorScheme.primary.withOpacity(0.55),
                            Colors.transparent,
                          ],
                          stops: const [0, 1],
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: widget.colorScheme.primary.withOpacity(0.4),
                        blurRadius: 42,
                        spreadRadius: 6,
                        offset: const Offset(-12, 20),
                      ),
                      BoxShadow(
                        color: Colors.black.withOpacity(0.28),
                        blurRadius: 34,
                        spreadRadius: 4,
                        offset: const Offset(18, 28),
                      ),
                    ],
                  ),
                  child: GlassmorphicContainer(
                    width: double.infinity,
                    height: 66,
                    borderRadius: 26,
                    blur: 25,
                    border: 1.2,
                    alignment: Alignment.center,
                    linearGradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(_isPressed ? 0.45 : 0.58),
                        widget.colorScheme.primary.withOpacity(0.18),
                        Colors.white.withOpacity(0.08),
                      ],
                      stops: const [0, 0.5, 1],
                    ),
                    borderGradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(0.82),
                        Colors.white.withOpacity(0.22),
                      ],
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned.fill(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.white.withOpacity(0.12),
                                  Colors.white.withOpacity(0.02),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 6,
                          left: 18,
                          right: 18,
                          child: Container(
                            height: 12,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.white.withOpacity(0.35),
                                  Colors.white.withOpacity(0.05),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 28,
                              vertical: 18,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(32),
                                    gradient: RadialGradient(
                                      colors: [
                                        const Color(0xFF70EFFF),
                                        widget.colorScheme.primary,
                                      ],
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.chat_bubble_outline_rounded,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Text('Open WhatsApp', style: textStyle),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
