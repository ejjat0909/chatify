import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/message_cubit.dart';
import '../cubit/message_state.dart';

class PreFilledMessageField extends StatefulWidget {
  const PreFilledMessageField({
    super.key,
    required this.colorScheme,
    required this.textTheme,
  });

  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  State<PreFilledMessageField> createState() => _PreFilledMessageFieldState();
}

class _PreFilledMessageFieldState extends State<PreFilledMessageField> {
  late final TextEditingController _messageController;

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
    _messageController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MessageCubit, MessageState>(
      listener: (context, state) {
        _messageController.text = state.combinedMessage;
      },
      child: TextField(
        controller: _messageController,
        maxLines: 1,
        style: widget.textTheme.bodyMedium?.copyWith(color: Colors.white),
        cursorColor: Colors.white70,
        decoration: InputDecoration(
          labelText: 'Message (Optional)',
          labelStyle: TextStyle(color: Colors.white.withOpacity(0.82)),
          hintText: 'Your pre-filled message...',
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.55)),
          filled: true,
          fillColor: Colors.white.withOpacity(0.12),
          suffixIcon: ValueListenableBuilder<TextEditingValue>(
            valueListenable: _messageController,
            builder: (context, value, child) {
              return value.text.isEmpty
                  ? const SizedBox.shrink()
                  : IconButton(
                      onPressed: () {
                        //  _messageController.clear();
                        // Clear arrival message from state, keeping greeting
                        context.read<MessageCubit>().clearArrivalMessage();
                      },
                      icon: Icon(
                        Icons.close_rounded,
                        color: Colors.white.withOpacity(0.55),
                      ),
                    );
            },
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 22,
            vertical: 20,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.white.withOpacity(0.18)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(
              color: widget.colorScheme.primary.withOpacity(0.85),
            ),
          ),
        ),
        readOnly: true,
      ),
    );
  }
}
