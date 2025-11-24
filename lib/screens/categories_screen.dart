import 'package:flutter/material.dart';
import '../models/category.dart';
import '../services/api_service.dart';
import '../widgets/category_card.dart';
import 'meals_by_category_screen.dart';
import 'meal_detail_screen.dart';

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
    }).catchError((e) {
      // ignore
    });
  }

  void _onSearchChanged(String q) {
    final lower = q.toLowerCase();
    setState(() {
      _filtered = _allCategories.where((c) => c.name.toLowerCase().contains(lower) || c.description.toLowerCase().contains(lower)).toList();
    });
  }

  Future<void> _openRandom() async {
    final mealDetail = await ApiService.fetchRandomMeal();
    if (mealDetail != null) {
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => MealDetailScreen(mealDetail: mealDetail)),
      );
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Can not load random recipe')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food categories'),
        actions: [
          IconButton(
            tooltip: 'Random recipe',
            icon: const Icon(Icons.casino),
            onPressed: _openRandom,
          )
        ],
      ),
      body: FutureBuilder<List<Category>>(
        future: _futureCategories,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting && _allCategories.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError && _allCategories.isEmpty) {
            return Center(child: Text('Error: ${snapshot.error}'));
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
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    final fresh = await ApiService.fetchCategories();
                    setState(() {
                      _allCategories = fresh;
                      _filtered = fresh;
                      _searchController.clear();
                    });
                  },
                  child: ListView.builder(
                    itemCount: _filtered.length,
                    itemBuilder: (context, index) {
                      final cat = _filtered[index];
                      return CategoryCard(
                        category: cat,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => MealsByCategoryScreen(category: cat.name)),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
