import 'package:flutter_app_recipes/data/services/auth_service.dart';
import 'package:flutter_app_recipes/di/service_locator.dart';
import 'package:flutter_app_recipes/ui/auth/auth_view.dart';
import 'package:flutter_app_recipes/ui/base_screen.dart';
import 'package:flutter_app_recipes/ui/recipes/recipes_view.dart';
import 'package:flutter_app_recipes/ui/recipesdetail/recipe_detail_view.dart';
import 'package:flutter_app_recipes/ui/fav_recipes/fav_recipes_view.dart';
import 'package:flutter_app_recipes/ui/profile/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  late final GoRouter router;

  final _service = getIt<AuthService>();

  late final ValueNotifier<bool> _authStateNotifier;

  AppRouter() {
    _authStateNotifier = ValueNotifier<bool>(_service.currentUser != null);
    _service.authStateChanges.listen((state) async {
      _authStateNotifier.value = _service.currentUser != null;
    });

    router = GoRouter(
      initialLocation: '/login',
      refreshListenable: _authStateNotifier,
      routes: [
        GoRoute(path: '/login', builder: (context, state) => const AuthView()),
        ShellRoute(
          builder: (context, state, child) => BaseScreen(child: child),
          routes: [
            GoRoute(path: '/', builder: (context, state) => RecipesView()),
            GoRoute(
              path: '/recipe/:id',
              builder: (context, state) =>
                RecipeDetailView(id: state.pathParameters['id']!),
            ),
            GoRoute(path: '/favorites', builder: (context, state) => FavRecipesView()),
            GoRoute(path: '/profile', builder: (context, state) => ProfileView()),
          ],
          redirect: (context, state) {
            final isLoggedIn = _authStateNotifier.value;
            final currentPath = state.uri.path;

            if(!isLoggedIn && currentPath != '/login') {
              return '/login';
            }
            if(isLoggedIn && currentPath == '/login') {
              return '/';
            }
            return null;
          },
        ),
      ],
    );
  }
}