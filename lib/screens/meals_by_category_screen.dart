import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../services/api_service.dart';
import '../widgets/meal_card.dart';
import 'meal_detail_screen.dart';

class MealsByCategoryScreen extends StatefulWidget {
  final String category;

  const MealsByCategoryScreen({super.key, required this.category});

  @override
  State<MealsByCategoryScreen> createState() => _MealsByCategoryScreenState();
}

class _MealsByCategoryScreenState extends State<MealsByCategoryScreen> {
  late Future<List<Meal>> _futureMeals;
  List<Meal> _allMeals = [];
  List<Meal> _filtered = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _futureMeals = ApiService.fetchMealsByCategory(widget.category);
    _futureMeals.then((list) {
      setState(() {
        _allMeals = list;
        _filtered = list;
      });
    }).catchError((e) {});
  }

  void _onSearchChanged(String q) async {
    final trimmed = q.trim();
    if (trimmed.isEmpty) {
      setState(() {
        _filtered = _allMeals;
      });
      return;
    }


    final lower = trimmed.toLowerCase();
    setState(() {
      _filtered = _allMeals.where((m) => m.name.toLowerCase().contains(lower)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food: ${widget.category}'),
      ),
      body: FutureBuilder<List<Meal>>(
        future: _futureMeals,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting && _allMeals.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError && _allMeals.isEmpty) {
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
                    hintText: 'Search meals by category...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    final fresh = await ApiService.fetchMealsByCategory(widget.category);
                    setState(() {
                      _allMeals = fresh;
                      _filtered = fresh;
                      _searchController.clear();
                    });
                  },
                  child: GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 3 / 4,
                    ),
                    itemCount: _filtered.length,
                    itemBuilder: (context, index) {
                      final meal = _filtered[index];
                      return MealCard(
                        meal: meal,
                        onTap: () async {
                          final detail = await ApiService.fetchMealDetail(meal.id);
                          if (detail != null && mounted) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => MealDetailScreen(mealDetail: detail)),
                            );
                          }
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
