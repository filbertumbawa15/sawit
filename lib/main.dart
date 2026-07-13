import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sawit/features/home/presentation/pages/dashboard_view.dart';
import 'package:sawit/features/home/presentation/pages/main_screen.dart';
import 'package:sawit/features/kontrol_operasional/presentation/bloc/form_master/form_master_bloc.dart';
import 'package:sawit/features/kontrol_operasional/presentation/bloc/kontroloperasional/kontroloperasional_bloc.dart';
import 'package:sawit/features/kontrol_operasional/presentation/pages/form_kontrol_operasional_h0_view.dart';
import 'package:sawit/screen/login_page_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'injection.dart' as di;
import 'features/auth/presentation/bloc/auth_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await di.init();
  final prefs = di.sl<SharedPreferences>();
  final String? token = prefs.getString('auth_token');
  final String initialRoute =
      (token != null && token.isNotEmpty) ? '/home' : '/login';
  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Saya',
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Nunito',
      ),

      // Daftar semua rute (URL) di aplikasi kamu
      routes: {
        '/login': (context) => BlocProvider(
              create: (_) => di.sl<AuthBloc>(),
              child: const LoginPageScreen(),
            ),
        '/home': (context) => BlocProvider(
              create: (_) => di.sl<KontrolOperasionalBloc>(),
              child: const MainScreen(),
            ),
        '/form_page_h0': (context) => BlocProvider(
              // Ambil instance BLoC dari GetIt (DI)
              create: (context) => di.sl<FormMasterBloc>(),
              child: const FormPageH0(),
            ),
      },
    );
  }
}
