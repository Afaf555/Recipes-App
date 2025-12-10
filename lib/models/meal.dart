class Meal {
  final String id;
  final String name;
  final String thumbnail;

  bool isFavorite; // <-- Додадено поле

  Meal({
    required this.id,
    required this.name,
    required this.thumbnail,
    this.isFavorite = false,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['idMeal'] as String,
      name: json['strMeal'] as String,
      thumbnail: json['strMealThumb'] as String,
    );
  }
}
