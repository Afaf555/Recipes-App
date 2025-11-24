import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/meal_detail.dart';

class MealDetailScreen extends StatelessWidget {
  final MealDetail mealDetail;

  const MealDetailScreen({super.key, required this.mealDetail});

  String _formatIngredients(Map<String, String> ingredients) {
    final lines = ingredients.entries.map((e) => '- ${e.key} : ${e.value}').toList();
    return lines.join('\n');
  }

  Future<void> _openYoutube(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    }
  }

  @override
  Widget build(BuildContext context) {
    final ingredientsText = _formatIngredients(mealDetail.ingredients);

    return Scaffold(
      appBar: AppBar(
        title: Text(mealDetail.name),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.network(
                  mealDetail.thumbnail,
                  height: 220,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(Icons.fastfood, size: 120),
                ),
              ),
              const SizedBox(height: 12),
              Text(mealDetail.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(children: [
                if (mealDetail.category.isNotEmpty) Text('Category: ${mealDetail.category}'),
                const SizedBox(width: 12),
                if (mealDetail.area.isNotEmpty) Text('Cuisine: ${mealDetail.area}'),
              ]),
              const SizedBox(height: 12),
              const Text('Ingredients:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text(ingredientsText),
              const SizedBox(height: 12),
              const Text('Instructions:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text(mealDetail.instructions),
              const SizedBox(height: 12),
              if (mealDetail.youtube.isNotEmpty)
                ElevatedButton.icon(
                  onPressed: () => _openYoutube(mealDetail.youtube),
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Open YouTube'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
