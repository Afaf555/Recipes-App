import 'package:flutter/material.dart';
import '../models/meal.dart';

class FavoritesService extends ChangeNotifier {
  final List<Meal> _favorites = [];

  List<Meal> get favorites => List.unmodifiable(_favorites);

  bool isFavorite(Meal meal) {
    return _favorites.any((m) => m.id == meal.id);
  }

  void toggleFavorite(Meal meal) {
    if (isFavorite(meal)) {
      _favorites.removeWhere((m) => m.id == meal.id);
      meal.isFavorite = false;
    } else {
      _favorites.add(meal);
      meal.isFavorite = true;
    }
    notifyListeners();
  }
}
