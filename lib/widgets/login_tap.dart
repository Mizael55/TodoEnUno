import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/presentation/auth/bloc/auth_bloc.dart';
import 'package:store/theme/app_colors.dart';
import '../presentation/screen/screen.dart';
import '../utils/utils.dart';

class LoginTab extends StatefulWidget {
  const LoginTab({super.key});

  @override
  State<LoginTab> createState() => _LoginTabState();
}

class _LoginTabState extends State<LoginTab> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          showDialog(
            context: context,
            builder:
                (context) => CustomAlert(
                  title: 'Error',
                  message: state.error,
                  type: AlertType.error,
                ),
          );
        } else if (state is AuthLoginSuccess) {
          // Navegar después de login exitoso
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const ProductCatalogScreen(),
            ),
          );
        } else if (state is AuthSignUpSuccess) {
          showDialog(
            context: context,
            builder:
                (context) => CustomAlert(
                  title: 'Registro exitoso',
                  message: 'Bienvenido/a',
                  type: AlertType.success,
                  onClose: () {
                    Navigator.of(context).pop();
                  },
                ),
          );
        }
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 20),
              CustomTextInput(
                label: 'Correo Electrónico',
                prefixIcon: Icons.email,
                inputType: CustomInputType.email,
                controller: _emailController,
              ),
              const SizedBox(height: 15),
              CustomTextInput(
                label: 'Contraseña',
                prefixIcon: Icons.lock,
                inputType: CustomInputType.password,
                controller: _passwordController,
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // Lógica para recuperar contraseña
                  },
                  child: const Text(
                    '¿Olvidaste tu contraseña?',
                    style: TextStyle(color: AppColors.secondary),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: AppColors.secondary,
                    foregroundColor: AppColors.buttonText,
                  ),
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      context.read<AuthBloc>().add(
                        LoginWithEmailAndPasswordRequested(
                          email: _emailController.text.trim(),
                          password: _passwordController.text.trim(),
                        ),
                      );
                    }
                  },
                  child: BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      if (state is AuthLoading) {
                        return const CircularProgressIndicator(
                          color: AppColors.buttonText,
                        );
                      }
                      return const Text(
                        'INICIAR SESIÓN',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Text(
                'O inicia sesión con',
                style: TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    backgroundColor: AppColors.cardBackground,
                    foregroundColor: AppColors.textPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 1,
                  ),
                  onPressed: () {
                    context.read<AuthBloc>().add(LoginWithGoogleRequested());
                  },
                  child: BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      if (state is AuthLoading) {
                        return const CircularProgressIndicator();
                      }
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/google.png',
                            width: 24,
                            height: 24,
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Continuar con Google',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
