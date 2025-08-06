import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/presentation/auth/bloc/auth_bloc.dart';
import 'package:store/theme/app_colors.dart';
import '../presentation/screen/screen.dart';
import '../utils/utils.dart';

class SignupTab extends StatefulWidget {
  const SignupTab({super.key});

  @override
  State<SignupTab> createState() => _SignupTabState();
}

class _SignupTabState extends State<SignupTab> {
  String? userType;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _fullNameController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _fullNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSignUpSuccess) {
          setState(() => _isLoading = false);
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const ProductCatalogScreen(),
            ),
          );
        } else if (state is AuthFailure) {
          setState(() => _isLoading = false);
          showDialog(
            context: context,
            builder:
                (context) => CustomAlert(
                  title: 'Error',
                  message: state.error,
                  type: AlertType.error,
                ),
          );
        } else if (state is AuthLoading) {
          setState(() => _isLoading = true);
        }
      },
      builder: (context, state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 20),
                CustomTextInput(
                  label: 'Nombre Completo',
                  prefixIcon: Icons.person,
                  controller: _fullNameController,
                  validator:
                      (value) =>
                          value?.isEmpty ?? true
                              ? 'Por favor ingresa tu nombre completo'
                              : null,
                ),
                const SizedBox(height: 15),
                CustomTextInput(
                  label: 'Correo Electrónico',
                  prefixIcon: Icons.email,
                  inputType: CustomInputType.email,
                  controller: _emailController,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Por favor ingresa tu correo';
                    }
                    if (!value!.contains('@')) {
                      return 'Correo electrónico inválido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                CustomTextInput(
                  label: 'Contraseña',
                  prefixIcon: Icons.lock,
                  inputType: CustomInputType.password,
                  controller: _passwordController,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Por favor ingresa una contraseña';
                    }
                    if (value!.length < 6) {
                      return 'Mínimo 6 caracteres';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),

                // Selector de tipo de usuario
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tipo de cuenta',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: RadioListTile<String>(
                              title: Text(
                                'Usuario',
                                style: TextStyle(color: AppColors.textPrimary),
                              ),
                              value: 'user',
                              groupValue: userType,
                              onChanged:
                                  (value) => setState(() => userType = value),
                              activeColor: AppColors.secondary,
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<String>(
                              title: Text(
                                'Venta',
                                style: TextStyle(color: AppColors.textPrimary),
                              ),
                              value: 'seller',
                              groupValue: userType,
                              onChanged:
                                  (value) => setState(() => userType = value),
                              activeColor: AppColors.secondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 15),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      backgroundColor: AppColors.secondary,
                      foregroundColor: AppColors.buttonText,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: _isLoading ? null : _handleSignUp,
                    child:
                        _isLoading
                            ? const CircularProgressIndicator(
                              color: AppColors.buttonText,
                            )
                            : const Text(
                              'REGISTRARSE',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                  ),
                ),

                const SizedBox(height: 20),
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
                    onPressed: _isLoading ? null : _handleGoogleSignUp,
                    child:
                        _isLoading
                            ? const CircularProgressIndicator()
                            : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/google.png',
                                  width: 24,
                                  height: 24,
                                ),
                                const SizedBox(width: 12),
                                const Text(
                                  'Registrate con Google',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleSignUp() {
    if (_formKey.currentState?.validate() ?? false) {
      if (userType != null) {
        context.read<AuthBloc>().add(
          SignUpWithEmailAndPasswordRequested(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
            fullName: _fullNameController.text.trim(),
            userType: userType!,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Selecciona un tipo de usuario')),
        );
      }
    }
  }

  void _handleGoogleSignUp() {
    if (userType != null) {
      context.read<AuthBloc>().add(
        SignUpWithGoogleRequested(userType: userType!),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona un tipo de cuenta')),
      );
    }
  }
}
