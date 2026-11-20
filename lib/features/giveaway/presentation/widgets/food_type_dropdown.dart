import 'package:flutter/material.dart';

class FoodTypeDropdown extends StatelessWidget {
  final String? initialValue;
  final ValueChanged<String?> onChanged;
  final String? Function(String?)? validator;

  const FoodTypeDropdown({
    super.key,
    required this.initialValue,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: initialValue,
      decoration: const InputDecoration(labelText: 'Food Type'),
      items: ['veg', 'non-veg', 'both'].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: onChanged,
      validator: validator,
    );
  }
}