import 'package:flutter_app_recipes/di/service_locator.dart';
import 'package:flutter_app_recipes/routes/app_routes.dart';
import 'package:flutter_app_recipes/utils/config/env.dart';
import 'package:flutter_app_recipes/utils/theme/custom_theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  // Garante que o Flutter está inicializado
  WidgetsFlutterBinding.ensureInitialized();

  // Carregar variáveis de ambiente
  await Env.init();

  // Inicializando o Supabase
  await Supabase.initialize(url: Env.supabaseUrl, anonKey: Env.supabaseAnonKey);

  // Inicializando as dependências
  await setupDependencies();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // * Get.put
    // Usado para injetar dependências no GetX
    final theme = Get.put(CustomThemeController());

    // * Obx
    // Usado para tornar um widget reativo
    return Obx(
      () => MaterialApp.router(
        title: 'I love Cooking',
        debugShowCheckedModeBanner: false,
        theme: theme.customTheme,
        darkTheme: theme.customThemeDark,
        themeMode: theme.isDark.value ? ThemeMode.dark : ThemeMode.light,
        routerConfig: AppRouter().router,
      ),
    );
  }
}
