// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class CustomAlert extends StatelessWidget {
  final String title;
  final String message;
  final AlertType type;
  final VoidCallback? onClose;
  final String? buttonText;

  const CustomAlert({
    super.key,
    required this.title,
    required this.message,
    required this.type,
    this.onClose,
    this.buttonText = 'Aceptar',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[900] : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icono superior
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _getIconBackgroundColor(context),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getIcon(),
                size: 32,
                color: _getIconColor(),
              ),
            ),
            const SizedBox(height: 20),

            // Título
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: _getTextColor(context),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            // Mensaje
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: _getTextColor(context).withOpacity(0.8),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Botón
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _getButtonColor(context),
                  foregroundColor: _getButtonTextColor(context),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: onClose ?? () => Navigator.of(context).pop(),
                child: Text(
                  buttonText!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIcon() {
    switch (type) {
      case AlertType.success:
        return Icons.check_circle_outlined;
      case AlertType.error:
        return Icons.error_outline;
      case AlertType.warning:
        return Icons.warning_amber_outlined;
      case AlertType.info:
        return Icons.info_outline;
    }
  }

  Color _getIconColor() {
    switch (type) {
      case AlertType.success:
        return Colors.green;
      case AlertType.error:
        return Colors.red;
      case AlertType.warning:
        return Colors.orange;
      case AlertType.info:
        return Colors.blue;
    }
  }

  Color _getIconBackgroundColor(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    switch (type) {
      case AlertType.success:
        return brightness == Brightness.dark 
            ? Colors.green.withOpacity(0.2) 
            : Colors.green.withOpacity(0.1);
      case AlertType.error:
        return brightness == Brightness.dark 
            ? Colors.red.withOpacity(0.2) 
            : Colors.red.withOpacity(0.1);
      case AlertType.warning:
        return brightness == Brightness.dark 
            ? Colors.orange.withOpacity(0.2) 
            : Colors.orange.withOpacity(0.1);
      case AlertType.info:
        return brightness == Brightness.dark 
            ? Colors.blue.withOpacity(0.2) 
            : Colors.blue.withOpacity(0.1);
    }
  }

  Color _getTextColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;
  }

  Color _getButtonColor(BuildContext context) {
    switch (type) {
      case AlertType.success:
        return Colors.green;
      case AlertType.error:
        return Colors.red;
      case AlertType.warning:
        return Colors.orange;
      case AlertType.info:
        return Colors.blue;
    }
  }

  Color _getButtonTextColor(BuildContext context) {
    return Colors.white;
  }
}

enum AlertType {
  success,
  error,
  warning,
  info,
}