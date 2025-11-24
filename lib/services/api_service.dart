import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category.dart';
import '../models/meal.dart';
import '../models/meal_detail.dart';

class ApiService {
  static const String base = 'https://www.themealdb.com/api/json/v1/1';


  static Future<List<Category>> fetchCategories() async {
    final uri = Uri.parse('$base/categories.php');
    final res = await http.get(uri);
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      final List cats = data['categories'] as List;
      return cats.map((e) => Category.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  static Future<List<Meal>> fetchMealsByCategory(String category) async {
    final uri = Uri.parse('$base/filter.php?c=${Uri.encodeComponent(category)}');
    final res = await http.get(uri);
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      final List? meals = data['meals'] as List?;
      if (meals == null) return [];
      return meals.map((e) => Meal.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load meals');
    }
  }

  static Future<List<Meal>> searchMeals(String query) async {
    final uri = Uri.parse('$base/search.php?s=${Uri.encodeComponent(query)}');
    final res = await http.get(uri);
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      final List? meals = data['meals'] as List?;
      if (meals == null) return [];
      return meals.map((e) => Meal.fromJson(e)).toList();
    } else {
      throw Exception('Failed to search meals');
    }
  }

  static Future<MealDetail?> fetchMealDetail(String id) async {
    final uri = Uri.parse('$base/lookup.php?i=${Uri.encodeComponent(id)}');
    final res = await http.get(uri);
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      final List? meals = data['meals'] as List?;
      if (meals == null || meals.isEmpty) return null;
      return MealDetail.fromJson(meals.first);
    } else {
      throw Exception('Failed to load meal detail');
    }
  }

  static Future<MealDetail?> fetchRandomMeal() async {
    final uri = Uri.parse('$base/random.php');
    final res = await http.get(uri);
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      final List? meals = data['meals'] as List?;
      if (meals == null || meals.isEmpty) return null;
      return MealDetail.fromJson(meals.first);
    } else {
      throw Exception('Failed to load random meal');
    }
  }
}
