import 'package:flutter_app_recipes/data/models/recipe.dart';
import 'package:flutter_app_recipes/data/repositories/recipe_repository.dart';
import 'package:flutter_app_recipes/di/service_locator.dart';
import 'package:get/get.dart';

class FavRecipesViewModel extends GetxController {
  final _repository = getIt<RecipeRepository>();
  final RxList<Recipe> _favRecipes = <Recipe>[].obs;
  final RxBool _isLoading = false.obs;
  final RxString _errorMessage = ''.obs;
  
  // Getters
  List<Recipe> get favRecipes => _favRecipes;
  bool get isLoading => _isLoading.value;
  String? get errorMessage => _errorMessage.value;

  Future<void> getFavRecipes() async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      final userId = '790e503c-30de-438c-9998-d7183cea4532';
      _favRecipes.value = await _repository.getFavRecipes(userId);
    } catch (e) {
      _errorMessage.value = 'Falha ao buscar receitas: ${e.toString()}';
    } finally {
      _isLoading.value = false;
    }
  }
}