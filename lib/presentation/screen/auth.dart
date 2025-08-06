import 'package:flutter/material.dart';
import 'package:store/theme/app_colors.dart';
import '../../widgets/widgets.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Bienvenidos/as',
            style: TextStyle(color: AppColors.textPrimary),
          ),
          centerTitle: true,
          backgroundColor: AppColors.primary,
          bottom: TabBar(
            tabs: const [
              Tab(icon: Icon(Icons.login), text: 'Iniciar Sesión'),
              Tab(icon: Icon(Icons.person_add), text: 'Registrarse'),
            ],
            indicatorColor: AppColors.secondary,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelColor: AppColors.textSecondary,
            labelColor: AppColors.secondary,
          ),
        ),
        body: Container(
          color: AppColors.background,
          child: const TabBarView(children: [LoginTab(), SignupTab()]),
        ),
      ),
    );
  }
}
