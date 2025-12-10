import 'package:flutter/material.dart';
import '../models/category.dart';
import '../services/api_service.dart';
import '../widgets/category_card.dart';
import 'meals_by_category_screen.dart';
import 'meal_detail_screen.dart';
import 'favorites_screen.dart';
import '../services/notification_service.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  late Future<List<Category>> _futureCategories;
  List<Category> _allCategories = [];
  List<Category> _filtered = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _futureCategories = ApiService.fetchCategories();
    _futureCategories.then((list) {
      setState(() {
        _allCategories = list;
        _filtered = list;
      });
    });
  }

  void _onSearchChanged(String q) {
    final lower = q.toLowerCase();
    setState(() {
      _filtered = _allCategories.where((c) =>
      c.name.toLowerCase().contains(lower) ||
          c.description.toLowerCase().contains(lower)).toList();
    });
  }

  Future<void> _openRandom() async {
    final mealDetail = await ApiService.fetchRandomMeal();
    if (mealDetail != null && mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => MealDetailScreen(mealDetail: mealDetail),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food categories'),
        actions: [
          /// ❤️ Favorites screen button
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const FavoritesScreen(),
                ),
              );
            },
          ),

          /// 🔔 Daily notification setter
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              NotificationService.scheduleDailyNotification(5, 22); // 20:00
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Daily notification set!')),
              );
            },
          ),

          /// 🎲 Random recipe
          IconButton(
            icon: const Icon(Icons.casino),
            onPressed: _openRandom,
          ),
        ],
      ),

      body: FutureBuilder<List<Category>>(
        future: _futureCategories,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting &&
              _filtered.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  decoration: InputDecoration(
                    hintText: 'Search categories...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _filtered.length,
                  itemBuilder: (context, index) {
                    final cat = _filtered[index];
                    return CategoryCard(
                      category: cat,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MealsByCategoryScreen(
                              category: cat.name,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
