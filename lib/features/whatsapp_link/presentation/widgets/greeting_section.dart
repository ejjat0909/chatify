import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../cubit/message_cubit.dart';
import '../cubit/message_state.dart';

class GreetingSection extends StatefulWidget {
  const GreetingSection({super.key, required this.textTheme});

  final TextTheme textTheme;

  @override
  State<GreetingSection> createState() => _GreetingSectionState();
}

class _GreetingSectionState extends State<GreetingSection> {
  late final TextEditingController _greetingController;

  @override
  void initState() {
    super.initState();
    _greetingController = TextEditingController();
  }

  @override
  void dispose() {
    _greetingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Greeting',
          style: widget.textTheme.bodySmall?.copyWith(
            color: Colors.white.withOpacity(0.65),
            fontWeight: FontWeight.w500,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 12),
        BlocBuilder<MessageCubit, MessageState>(
          builder: (context, state) {
            // Sync controller with bloc state
            if (_greetingController.text != state.greetingMessage) {
              _greetingController.text = state.greetingMessage;
            }
            return _GreetingButton(
              controller: _greetingController,
              textTheme: widget.textTheme,
            );
          },
        ),
      ],
    );
  }
}

class _GreetingButton extends StatefulWidget {
  const _GreetingButton({required this.controller, required this.textTheme});

  final TextEditingController controller;
  final TextTheme textTheme;

  @override
  State<_GreetingButton> createState() => _GreetingButtonState();
}

class _GreetingButtonState extends State<_GreetingButton> {
  bool _isPressed = false;
  bool _isEditMode = false;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _toggleEditMode() {
    if (_isEditMode) {
      // Exit edit mode - save the message to secure storage
      context.read<MessageCubit>().updateGreetingMessage(
        widget.controller.text,
      );
    }
    setState(() {
      _isEditMode = !_isEditMode;
      if (_isEditMode) {
        // Enter edit mode - auto focus and select text
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _focusNode.requestFocus();
          widget.controller.selection = TextSelection(
            baseOffset: 0,
            extentOffset: widget.controller.text.length,
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isEditMode ? _buildEditMode() : _buildViewMode();
  }

  Widget _buildViewMode() {
    return BlocBuilder<MessageCubit, MessageState>(
      builder: (context, state) {
        final savedGreeting = state.greetingMessage;
        return GestureDetector(
          onTapDown: (_) => setState(() => _isPressed = true),
          onTapUp: (_) {
            setState(() => _isPressed = false);
            _toggleEditMode();
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
                    color: Colors.white.withOpacity(0.1),
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
                height: 48,
                borderRadius: 16,
                blur: 18,
                border: 1.1,
                alignment: Alignment.center,
                linearGradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(_isPressed ? 0.35 : 0.45),
                    Colors.white.withOpacity(0.1),
                    Colors.white.withOpacity(0.04),
                  ],
                ),
                borderGradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.7),
                    Colors.white.withOpacity(0.15),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          savedGreeting.isEmpty
                              ? 'Enter greeting message'
                              : savedGreeting,
                          textAlign: TextAlign.center,
                          style: widget.textTheme.bodyMedium?.copyWith(
                            color: savedGreeting.isEmpty
                                ? Colors.white.withOpacity(0.5)
                                : Colors.white.withOpacity(0.9),
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.3,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: _toggleEditMode,
                        child: Icon(
                          Icons.edit_rounded,
                          color: Colors.white.withOpacity(0.7),
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEditMode() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: _focusNode.hasFocus
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
        height: 48,
        borderRadius: 16,
        blur: 18,
        border: 1.1,
        alignment: Alignment.center,
        linearGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: _focusNode.hasFocus
              ? [
                  Colors.cyan.withOpacity(0.55),
                  Colors.cyan.withOpacity(0.15),
                  Colors.white.withOpacity(0.08),
                ]
              : [
                  Colors.white.withOpacity(0.45),
                  Colors.white.withOpacity(0.1),
                  Colors.white.withOpacity(0.04),
                ],
        ),
        borderGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: _focusNode.hasFocus
              ? [Colors.cyan.withOpacity(0.8), Colors.cyan.withOpacity(0.3)]
              : [Colors.white.withOpacity(0.7), Colors.white.withOpacity(0.15)],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  focusNode: _focusNode,
                  onChanged: (value) {
                    // Fire-and-forget: async save to secure storage
                    context.read<MessageCubit>().updateGreetingMessage(value);
                  },
                  style: widget.textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withOpacity(0.9),
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter greeting message',
                    hintStyle: widget.textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withOpacity(0.5),
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.3,
                    ),
                    contentPadding: EdgeInsets.zero,
                  ),
                  cursorColor: Colors.cyan.withOpacity(0.8),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: _toggleEditMode,
                child: Icon(
                  Icons.check_rounded,
                  color: Colors.cyan.withOpacity(0.8),
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
