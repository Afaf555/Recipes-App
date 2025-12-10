import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/favorites_service.dart';
import '../widgets/meal_card.dart';
import '../services/api_service.dart';
import 'meal_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {

  // ✔️ ДОДАДЕНО – ова го решава routeName error!
  static const routeName = '/favorites';

  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favs = context.watch<FavoritesService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Recipes'),
      ),
      body: favs.favorites.isEmpty
          ? const Center(
        child: Text(
          'No favorites yet',
          style: TextStyle(fontSize: 18),
        ),
      )
          : GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 4,
        ),
        itemCount: favs.favorites.length,
        itemBuilder: (context, index) {
          final meal = favs.favorites[index];

          return MealCard(
            meal: meal,
            onTap: () async {
              final detail = await ApiService.fetchMealDetail(meal.id);
              if (detail != null && context.mounted) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        MealDetailScreen(mealDetail: detail),
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
}
