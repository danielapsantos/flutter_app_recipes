import 'package:flutter_app_recipes/data/repositories/auth_repository.dart';
import 'package:flutter_app_recipes/data/repositories/recipe_repository.dart';
import 'package:flutter_app_recipes/data/services/auth_service.dart';
import 'package:flutter_app_recipes/data/services/recipe_service.dart';
import 'package:flutter_app_recipes/ui/auth/auth_viewmodel.dart';
import 'package:flutter_app_recipes/ui/fav_recipes/fav_recipes_viewmodel.dart';
import 'package:flutter_app_recipes/ui/profile/profile_viewmodel.dart';
import 'package:flutter_app_recipes/ui/recipesdetail/recipe_detail_viewmodel.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_app_recipes/ui/recipes/recipes_viewmodel.dart';


final getIt = GetIt.instance;

Future<void> setupDependencies() async {

  // SupabaseClient
  getIt.registerSingleton<SupabaseClient>(Supabase.instance.client);

  // Services
  getIt.registerLazySingleton<RecipeService>(() => RecipeService());
  getIt.registerLazySingleton<AuthService>(() => AuthService());

  // Repositories
  getIt.registerLazySingleton<RecipeRepository>(() => RecipeRepository());
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepository());

  // Recipe ViewModel
  getIt.registerLazySingleton<RecipesViewModel>(() => RecipesViewModel());

  //Recipe ViewModelDetail
  getIt.registerLazySingleton<RecipeDetailViewModel>(() => RecipeDetailViewModel());

  getIt.registerLazySingleton<FavRecipesViewModel>(() => FavRecipesViewModel());

  getIt.registerLazySingleton<AuthViewModel>(() => AuthViewModel());
  
  getIt.registerLazySingleton<ProfileViewModel>(() => ProfileViewModel());
}