import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/firebase_options.dart';
import 'package:store/presentation/auth/bloc/auth_bloc.dart';
import 'package:store/presentation/auth/bloc/repositories/auth_repository.dart';
import 'package:store/presentation/produc/bloc/product_bloc.dart';
import 'package:store/presentation/produc/bloc/repositories/product_repository.dart';
import 'package:store/presentation/produc/bloc/services/firebase_storage_service.dart';
import 'package:store/theme/app_theme.dart';

import 'presentation/screen/screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => AuthRepository()),
        RepositoryProvider(create: (context) => ProductRepository()),
        RepositoryProvider(create: (context) => FirebaseStorageService()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(
              authRepository: RepositoryProvider.of<AuthRepository>(context),
            ),
          ),
          BlocProvider(
            create: (context) => ProductBloc(
              productRepository: RepositoryProvider.of<ProductRepository>(context),
              storageService: RepositoryProvider.of<FirebaseStorageService>(context),
            ),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'APP Tiendas',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          onGenerateRoute: (settings) {
            // Manejo de rutas con argumentos si es necesario
            return MaterialPageRoute(
              builder: (context) => const WelcomeScreen(),
            );
          },
        ),
      ),
    );
  }
}