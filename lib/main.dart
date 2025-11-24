import 'package:flutter/material.dart';
import 'screens/categories_screen.dart';

void main() {
  runApp(const ExamRecipesApp());
}

class ExamRecipesApp extends StatelessWidget {
  const ExamRecipesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ExamRecipes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: const CategoriesScreen(),
    );
  }
}
