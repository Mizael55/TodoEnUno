// lib/widgets/custom_switch_input.dart
import 'package:flutter/material.dart';

class CustomSwitchInput extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  final EdgeInsetsGeometry? contentPadding;

  const CustomSwitchInput({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      contentPadding: contentPadding,
      title: Text(label),
      value: value,
      onChanged: onChanged,
    );
  }
}
