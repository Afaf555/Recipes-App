class MealDetail {
  final String id;
  final String name;
  final String category;
  final String area;
  final String instructions;
  final String thumbnail;
  final String youtube;
  final Map<String, String> ingredients; // ingredient -> measure

  MealDetail({
    required this.id,
    required this.name,
    required this.category,
    required this.area,
    required this.instructions,
    required this.thumbnail,
    required this.youtube,
    required this.ingredients,
  });

  factory MealDetail.fromJson(Map<String, dynamic> json) {
    final Map<String, String> ingredients = {};
    for (int i = 1; i <= 20; i++) {
      final ing = json['strIngredient$i'];
      final measure = json['strMeasure$i'];
      if (ing != null && (ing as String).trim().isNotEmpty) {
        ingredients[ing as String] = (measure as String?)?.trim() ?? '';
      }
    }

    return MealDetail(
      id: json['idMeal'] as String,
      name: json['strMeal'] as String,
      category: (json['strCategory'] as String?) ?? '',
      area: (json['strArea'] as String?) ?? '',
      instructions: (json['strInstructions'] as String?) ?? '',
      thumbnail: (json['strMealThumb'] as String?) ?? '',
      youtube: (json['strYoutube'] as String?) ?? '',
      ingredients: ingredients,
    );
  }
}
