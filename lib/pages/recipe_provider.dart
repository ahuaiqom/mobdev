import 'package:flutter/material.dart';

class RecipeProvider with ChangeNotifier {
  List<Map<String, dynamic>> _savedRecipes = [];

  List<Map<String, dynamic>> get savedRecipes => _savedRecipes;

  void addRecipe(Map<String, dynamic> recipe) {
    _savedRecipes.add(recipe);
    notifyListeners();
  }

  void removeRecipe(String title) {
    _savedRecipes.removeWhere((recipe) => recipe["title"] == title);
    notifyListeners();
  }
}
