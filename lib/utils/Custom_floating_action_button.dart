import 'package:flutter/material.dart';
import '../presentation/screen/screen.dart';

class CustomFloatingActionButton extends StatelessWidget {
  final BuildContext context;
  final VoidCallback? onPressedCallback;
  final Color backgroundColor;
  final Color foregroundColor;
  final double elevation;
  final BorderRadius borderRadius;
  final Color borderColor;
  final double borderWidth;
  final String label;
  final IconData icon;

  const CustomFloatingActionButton({
    Key? key,
    required this.context,
    this.onPressedCallback,
    required this.backgroundColor,
    this.foregroundColor = Colors.white,
    this.elevation = 8,
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
    this.borderColor = Colors.white,
    this.borderWidth = 2,
    required this.label,
    this.icon = Icons.add,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: onPressedCallback ?? _defaultOnPressed,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      elevation: elevation,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius,
        side: BorderSide(color: borderColor, width: borderWidth),
      ),
      label: Text(label),
      icon: Icon(icon),
    );
  }

  void _defaultOnPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddProductScreen()),
    ).then((_) {
      // Notificar al padre que debe actualizarse si es necesario
      if (context.mounted) {
        // Verificar que el widget todavía está en el árbol
        final StatefulElement? element = context as StatefulElement?;
        element?.markNeedsBuild();
      }
    });
  }
}
