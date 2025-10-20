import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../cubit/message_cubit.dart';
import '../cubit/message_state.dart';

class ArrivalTimeSection extends StatelessWidget {
  const ArrivalTimeSection({super.key, required this.textTheme});

  static const List<String> arrivalTimes = [
    'Arrive in 5 minutes',
    'Arrive in 10 minutes',
    'Arrive in 15 minutes',
    'Arrive in 20 minutes',
  ];

  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Arrival Time',
          style: textTheme.bodySmall?.copyWith(
            color: Colors.white.withOpacity(0.65),
            fontWeight: FontWeight.w500,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 12),
        BlocBuilder<MessageCubit, MessageState>(
          builder: (context, state) {
            return GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 6.0,
              crossAxisSpacing: 8.0,
              childAspectRatio: 3.3,
              children: [
                for (final time in arrivalTimes)
                  _ArrivalTimeButton(
                    label: time,
                    isSelected: state.arrivalMessage == time,
                    onPressed: () {
                      context.read<MessageCubit>().updateArrivalMessage(time);
                    },
                    textTheme: textTheme,
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _ArrivalTimeButton extends StatefulWidget {
  const _ArrivalTimeButton({
    required this.label,
    required this.isSelected,
    required this.onPressed,
    required this.textTheme,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onPressed;
  final TextTheme textTheme;

  @override
  State<_ArrivalTimeButton> createState() => _ArrivalTimeButtonState();
}

class _ArrivalTimeButtonState extends State<_ArrivalTimeButton> {
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
                color: widget.isSelected
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
              colors: widget.isSelected
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
              colors: widget.isSelected
                  ? [Colors.cyan.withOpacity(0.8), Colors.cyan.withOpacity(0.3)]
                  : [
                      Colors.white.withOpacity(0.7),
                      Colors.white.withOpacity(0.15),
                    ],
            ),
            child: Text(
              widget.label,
              style: widget.textTheme.bodyMedium?.copyWith(
                color: Colors.white.withOpacity(0.9),
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
