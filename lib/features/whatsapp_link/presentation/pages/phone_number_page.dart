import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/phone_number_cubit.dart';
import '../cubit/phone_number_state.dart';

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
    return Scaffold(
      appBar: AppBar(title: const Text('Chatify'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter Malaysian phone number',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            BlocBuilder<PhoneNumberCubit, PhoneNumberState>(
              builder: (context, state) {
                return TextField(
                  controller: _controller,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: 'e.g. 013-456 7890',
                    errorText: state.validationError,
                    border: const OutlineInputBorder(),
                    suffixIcon: state.input.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _controller.clear();
                              context.read<PhoneNumberCubit>().updateInput('');
                            },
                          )
                        : null,
                  ),
                  onChanged: context.read<PhoneNumberCubit>().updateInput,
                );
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final clipboardData = await Clipboard.getData('text/plain');
                  final clipboardText = clipboardData?.text?.trim() ?? '';
                  if (clipboardText.isEmpty) {
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Clipboard is empty.')),
                    );
                    return;
                  }

                  final validationError = context
                      .read<PhoneNumberCubit>()
                      .validateMalaysianNumber(clipboardText);
                  if (validationError != null) {
                    if (!mounted) return;
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text("Phone Number is invalid.")));
                    return;
                  }

                  _controller.value = TextEditingValue(
                    text: clipboardText,
                    selection: TextSelection.collapsed(
                      offset: clipboardText.length,
                    ),
                  );
                  context.read<PhoneNumberCubit>().updateInput(clipboardText);
                },
                child: const Text('Paste phone number'),
              ),
            ),
            const SizedBox(height: 16),
            BlocConsumer<PhoneNumberCubit, PhoneNumberState>(
              listener: (context, state) {
                // Only show snackbar for launch errors
                if (state.launchError != null) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.launchError!)));
                }
              },
              builder: (context, state) {
                if (state.status == PhoneNumberStatus.launchRequested) {
                  return const Center(child: CircularProgressIndicator());
                }

                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: state.isValid
                        ? () =>
                              context.read<PhoneNumberCubit>().launchWhatsApp()
                        : null,
                    icon: const Icon(Icons.chat),
                    label: const Text('Open WhatsApp'),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            const Text(
              'Note: This will open WhatsApp externally.',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
