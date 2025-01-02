import 'package:flutter/material.dart';
import 'recipe_instruction_page.dart';

class RecipeDetailPage extends StatefulWidget {
  final String recipeTitle;
  final String description;
  final String imageUrl;
  final String location;
  final String cookingTime;
  final String difficulty;
  final List<String> mainIngredients;
  final List<String> instructions;

  const RecipeDetailPage({
    required this.recipeTitle,
    required this.description,
    required this.imageUrl,
    required this.location,
    required this.cookingTime,
    required this.difficulty,
    required this.mainIngredients,
    required this.instructions,
    Key? key, required onAddToHistory,
  }) : super(key: key);

  @override
  _RecipeDetailPageState createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {
  final List<Map<String, dynamic>> historyItems = [];

  void onAddToHistory(Map<String, dynamic> recipe) {
    setState(() {
      historyItems.add(recipe);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          widget.recipeTitle,
          style: const TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.asset(
                    widget.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Text(
                          'Image not found',
                          style: TextStyle(color: Colors.red, fontSize: 16),
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Card(
                    color: Colors.black.withOpacity(0.7),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.recipeTitle,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.location_on, color: Colors.white, size: 16),
                                  const SizedBox(width: 4),
                                  Text(
                                    widget.location,
                                    style: const TextStyle(color: Colors.white, fontSize: 14),
                                  ),
                                ],
                              ),
                              const Text(
                                'Free',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Overview',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.access_time, size: 20),
                          const SizedBox(width: 4),
                          Text(widget.cookingTime),
                        ],
                      ),
                      const SizedBox(width: 16),
                      Row(
                        children: [
                          const Icon(Icons.star, size: 20, color: Colors.amber),
                          const SizedBox(width: 4),
                          const Text('4.5'),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.description,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Tambahkan ke history sebelum navigasi
                      onAddToHistory({
                        "title": widget.recipeTitle,
                        "description": widget.description,
                        "image": widget.imageUrl,
                        "location": widget.location,
                        "cookingTime": widget.cookingTime,
                        "difficulty": widget.difficulty,
                        "mainIngredients": widget.mainIngredients,
                        "instructions": widget.instructions,
                      });

                      // Navigasi ke RecipeInstructionPage
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecipeInstructionPage(
                            recipeTitle: widget.recipeTitle,
                            location: widget.location,
                            difficulty: widget.difficulty,
                            cookingTime: widget.cookingTime,
                            imageUrl: widget.imageUrl,
                            mainIngredients: widget.mainIngredients,
                            instructions: widget.instructions,
                            onAddToHistory: (recipe) => onAddToHistory(recipe as Map<String, dynamic>),
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Center(
                      child: Text(
                        'Cook Now',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
