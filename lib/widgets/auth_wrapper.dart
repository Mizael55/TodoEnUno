// Widget que maneja la lógica de redirección basada en el estado de autenticación
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/presentation/auth/bloc/auth_bloc.dart';
import '../presentation/screen/screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthInitial) {
          return const WelcomeScreen();
        } else if (state is AuthLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (state is AuthLoginSuccess || state is AuthSignUpSuccess) {
          return const ProductCatalogScreen();
        } else if (state is AuthFailure) {
          return ErrorScreen(error: state.error);
        } else {
          return const WelcomeScreen();
        }
      },
    );
  }
}
