import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimePicker extends StatelessWidget {
  final DateTime? selectedDateTime;
  final String label;
  final VoidCallback onPressed;

  const DateTimePicker({
    super.key,
    required this.selectedDateTime,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            selectedDateTime == null
                ? '$label: Not selected'
                : '$label: ${DateFormat('yyyy-MM-dd HH:mm').format(selectedDateTime!)}',
          ),
        ),
        ElevatedButton(
          onPressed: onPressed,
          child: Text('Select $label'),
        ),
      ],
    );
  }
}