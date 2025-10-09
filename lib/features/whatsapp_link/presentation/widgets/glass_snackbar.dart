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
                    child: GlassmorphicContainer(
                      width: double.infinity,
                      height: 72,
                      borderRadius: 18,
                      blur: 25,
                      border: 1.5,
                      linearGradient: LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0.32),
                          Colors.white.withOpacity(0.08),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderGradient: LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0.55),
                          Colors.white.withOpacity(0.12),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: colorScheme.primary,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  widget.message,
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: Colors.white.withOpacity(0.94),
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
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
