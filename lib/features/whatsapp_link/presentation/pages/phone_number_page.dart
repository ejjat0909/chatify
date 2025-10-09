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
  String version = "";

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
        title: _GlassAppBarTitle(
          colorScheme: colorScheme,
          textTheme: textTheme,
        ),
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
                            mainAxisAlignment: MainAxisAlignment.center,
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
                                        borderRadius: BorderRadius.circular(10),
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
                                      fillColor: Colors.white.withOpacity(0.12),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 22,
                                            vertical: 20,
                                          ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide(
                                          color: Colors.white.withOpacity(0.18),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide(
                                          color: colorScheme.primary
                                              .withOpacity(0.85),
                                        ),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide(
                                          color: colorScheme.error,
                                        ),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
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
                        child: Text("Chatify v$version"),
                      ),
                    ],
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
