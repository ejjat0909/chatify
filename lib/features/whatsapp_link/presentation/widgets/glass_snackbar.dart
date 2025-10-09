import 'dart:async';

import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';

/// Shows a glassmorphic styled snackbar using an [OverlayEntry].
///
/// This helper avoids the default [SnackBar] appearance so the design can
/// embrace the app's glass aesthetic.
void showGlassSnackbar(
  BuildContext context, {
  required String message,
  Duration duration = const Duration(milliseconds: 2800),
}) {
  final overlay = Overlay.of(context, rootOverlay: true);

  late OverlayEntry entry;
  entry = OverlayEntry(
    builder: (context) => _GlassSnackbar(
      message: message,
      duration: duration,
      onDismissed: () {
        if (entry.mounted) {
          entry.remove();
        }
      },
    ),
  );

  overlay.insert(entry);
}

class _GlassSnackbar extends StatefulWidget {
  const _GlassSnackbar({
    required this.message,
    required this.duration,
    required this.onDismissed,
  });

  final String message;
  final Duration duration;
  final VoidCallback onDismissed;

  @override
  State<_GlassSnackbar> createState() => _GlassSnackbarState();
}

class _GlassSnackbarState extends State<_GlassSnackbar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;
  Timer? _dismissTimer;
  bool _isDismissing = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
      reverseDuration: const Duration(milliseconds: 240),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.easeOutBack,
            reverseCurve: Curves.easeInBack,
          ),
        );

    _controller.forward();
    _dismissTimer = Timer(widget.duration, _dismiss);
  }

  Future<void> _dismiss() async {
    if (_isDismissing) return;
    _isDismissing = true;

    if (mounted) {
      await _controller.reverse();
      if (mounted) {
        widget.onDismissed();
      }
    }
  }

  @override
  void dispose() {
    _dismissTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Positioned.fill(
      child: IgnorePointer(
        ignoring: true,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 24 + bottomInset),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF37CFFF).withOpacity(0.35),
                            blurRadius: 32,
                            spreadRadius: 4,
                            offset: const Offset(-8, 16),
                          ),
                          BoxShadow(
                            color: Colors.black.withOpacity(0.28),
                            blurRadius: 28,
                            spreadRadius: 2,
                            offset: const Offset(10, 18),
                          ),
                        ],
                      ),
                      child: GlassmorphicContainer(
                        width: double.infinity,
                        height: 80,
                        borderRadius: 24,
                        blur: 28,
                        border: 1.2,
                        linearGradient: LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0.6),
                            const Color(0xFF74E7FF).withOpacity(0.18),
                            Colors.white.withOpacity(0.05),
                          ],
                          stops: const [0, 0.55, 1],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderGradient: LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0.8),
                            Colors.white.withOpacity(0.18),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Positioned(
                              top: -25,
                              right: -20,
                              child: Container(
                                width: 88,
                                height: 88,
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
                            Positioned(
                              bottom: -30,
                              left: -18,
                              child: Container(
                                width: 98,
                                height: 98,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(120),
                                  gradient: RadialGradient(
                                    colors: [
                                      const Color(0xFF55D4FF).withOpacity(0.55),
                                      Colors.transparent,
                                    ],
                                    stops: const [0, 1],
                                  ),
                                ),
                              ),
                            ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 22,
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 18,
                                      height: 18,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        gradient: const RadialGradient(
                                          colors: [
                                            Color(0xFF6FE7FF),
                                            Color(0xFF1FA6FF),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Text(
                                        widget.message,
                                        style: textTheme.bodyMedium?.copyWith(
                                          color: Colors.white.withOpacity(0.95),
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0.2,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
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
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
