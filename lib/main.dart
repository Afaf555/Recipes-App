import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'services/favorites_service.dart';
import 'services/api_service.dart';
import 'screens/categories_screen.dart';
import 'screens/favorites_screen.dart';
import 'screens/meal_detail_screen.dart';


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Notification init
  const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
  const initSettings = InitializationSettings(android: androidInit);

  await flutterLocalNotificationsPlugin.initialize(
    initSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) async {
      final payload = response.payload;
      if (payload == null) return;

      final data = jsonDecode(payload);
      final mealId = data["id"];

      if (mealId == null) return;

      final mealDetail = await ApiService.fetchMealDetail(mealId);
      if (mealDetail == null) return;

      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (_) => MealDetailScreen(mealDetail: mealDetail),
        ),
      );
    },
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => FavoritesService(),
      child: const ExamRecipesApp(),
    ),
  );
}

class ExamRecipesApp extends StatelessWidget {
  const ExamRecipesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      home: const CategoriesScreen(),
      routes: {
        FavoritesScreen.routeName: (_) => const FavoritesScreen(),
      },
    );
  }
}
