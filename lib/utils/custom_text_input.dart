// lib/widgets/custom_text_input.dart
import 'package:flutter/material.dart';

enum CustomInputType { text, email, number, password }

class CustomTextInput extends StatefulWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final CustomInputType inputType;
  final IconData? prefixIcon;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String?)? onSaved;
  final bool enabled;
  final TextCapitalization textCapitalization;
  final int? maxLines;

  const CustomTextInput({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.inputType = CustomInputType.text,
    this.prefixIcon,
    this.validator,
    this.onChanged,
    this.onSaved,
    this.enabled = true,
    this.textCapitalization = TextCapitalization.none,
    this.maxLines = 1,
  });

  @override
  State<CustomTextInput> createState() => _CustomTextInputState();
}

class _CustomTextInputState extends State<CustomTextInput> {
  late bool _obscure;

  TextInputType get _keyboardType {
    switch (widget.inputType) {
      case CustomInputType.email:
        return TextInputType.emailAddress;
      case CustomInputType.number:
        return TextInputType.numberWithOptions(decimal: true);
      default:
        return TextInputType.text;
    }
  }

  @override
  void initState() {
    super.initState();
    _obscure = widget.inputType == CustomInputType.password;
  }

  @override
  Widget build(BuildContext context) {
    final suffix = widget.inputType == CustomInputType.password
        ? IconButton(
            icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
            onPressed: () => setState(() => _obscure = !_obscure),
          )
        : null;

    return TextFormField(
      controller: widget.controller,
      keyboardType: _keyboardType,
      obscureText: _obscure,
      validator: widget.validator ?? _defaultValidator,
      onChanged: widget.onChanged,
      onSaved: widget.onSaved,
      enabled: widget.enabled,
      textCapitalization: widget.textCapitalization,
      maxLines: widget.maxLines,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        prefixIcon: widget.prefixIcon != null ? Icon(widget.prefixIcon) : null,
        suffixIcon: suffix,
      ),
    );
  }

  String? _defaultValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es obligatorio';
    }
    if (widget.inputType == CustomInputType.email) {
      final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
      if (!emailRegex.hasMatch(value)) return 'Ingresa un correo válido';
    }
    if (widget.inputType == CustomInputType.number) {
      final numValue = num.tryParse(value.replaceAll(',', '.'));
      if (numValue == null) return 'Ingresa un número válido';
    }
    return null;
  }
}
