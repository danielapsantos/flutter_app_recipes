import 'package:flutter_app_recipes/di/service_locator.dart';
import 'package:flutter_app_recipes/ui/recipes/recipes_viewmodel.dart';
import 'package:flutter_app_recipes/ui/widgets/recipe_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class RecipesView extends StatefulWidget {
  const RecipesView({super.key});

  @override
  State<RecipesView> createState() => _RecipesViewState();
}

class _RecipesViewState extends State<RecipesView>
    with SingleTickerProviderStateMixin {
  final viewModel = getIt<RecipesViewModel>();

  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _animation = Tween(begin: 0.0, end: 200.0).animate(_animationController)
      ..addListener(() => setState(() {}));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.getRecipes();
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (viewModel.isLoading) {
        return Center(
          child: SizedBox(
            height: 96,
            width: 96,
            child: CircularProgressIndicator(strokeWidth: 12),
          ),
        );
      }

      if (viewModel.errorMessage != '') {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Erro: ${viewModel.errorMessage}',
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    viewModel.getRecipes();
                  },
                  child: const Text('TRY AGAIN'),
                ),
              ],
            ),
          ),
        );
      }

      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: viewModel.recipes.isNotEmpty
                  ? Column(
                      children: [
                        Text(
                          '${viewModel.recipes.length} receita(s)',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(top: 200 - _animation.value),
                            child: ListView.builder(
                              itemCount: viewModel.recipes.length,
                              itemBuilder: (context, index) {
                                final recipe = viewModel.recipes[index];

                                // Se quiser usar favoritos futuramente:
                                // final isFavorite = viewModel.favRecipes.any((fav) => fav.id == recipe.id);

                                return Stack(
                                  children: [
                                    GestureDetector(
                                      onTap: () => context.go('/recipe/${recipe.id}'),
                                      child: RecipeCard(recipe: recipe),
                                    ),

                                    // Aqui você pode descomentar o bloco de favoritos se quiser implementar:
                                    /*
                                    Positioned(
                                      top: 16,
                                      right: 16,
                                      child: IconButton(
                                        icon: Icon(
                                          isFavorite ? Icons.favorite : Icons.favorite_border,
                                          size: 32,
                                          color: isFavorite ? Colors.red : null,
                                        ),
                                        onPressed: () {
                                          // lógica de adicionar/remover favorito
                                        },
                                      ),
                                    ),
                                    */
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    )
                  : Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 64),
                          Icon(
                            Icons.favorite,
                            size: 96,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(height: 32),
                          const Text(
                            'Adicione suas receitas favoritas!',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      );
    });
  }
}