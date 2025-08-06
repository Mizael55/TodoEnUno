// lib/widgets/custom_checkbox_input.dart
import 'package:flutter/material.dart';

class CustomCheckboxInput extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool?> onChanged;
  final bool tristate;
  final EdgeInsetsGeometry? contentPadding;

  const CustomCheckboxInput({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.tristate = false,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      contentPadding: contentPadding,
      title: Text(label),
      value: value,
      onChanged: onChanged,
      controlAffinity: ListTileControlAffinity.leading,
    );
  }
}
