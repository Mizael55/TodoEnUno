// genera una pantalla de error personalizada
import 'package:flutter/material.dart';
import 'package:store/theme/app_colors.dart';

class ErrorScreen extends StatelessWidget {
  final String error;

  const ErrorScreen({Key? key, required this.error}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
        backgroundColor: AppColors.secondary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error, size: 100, color: AppColors.error),
            const SizedBox(height: 20),
            Text(
              error,
              style: const TextStyle(fontSize: 18, color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Volver'),
            ),
          ],
        ),
      ),
    );
  }
}