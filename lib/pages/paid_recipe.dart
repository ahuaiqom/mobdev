import 'package:flutter/material.dart';
import 'payments_page.dart';

class PaidRecipeDetailPage extends StatefulWidget {
  final String recipeTitle;
  final String description;
  final String imageUrl;
  final String price;
  final String location;
  final String cookingTime; 
  final String difficulty;
  final List<String> mainIngredients; 
  final List<String> instructions; 

  const PaidRecipeDetailPage({                     
    required this.recipeTitle,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.location,
    required this.cookingTime,
    required this.difficulty,
    required this.mainIngredients,
    required this.instructions, // Accept dynamic instructions
    Key? key,
  }) : super(key: key);

  @override
  _PaidRecipeDetailPageState createState() => _PaidRecipeDetailPageState();
}

class _PaidRecipeDetailPageState extends State<PaidRecipeDetailPage> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          widget.recipeTitle,
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
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
                      return Center(
                        child: Text(
                          'Image not found',
                          style: TextStyle(color: Colors.red, fontSize: 16),
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        isFavorite = !isFavorite;
                      });
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
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.location_on, color: Colors.white, size: 16),
                              SizedBox(width: 4),
                              Text(
                                widget.location,
                                style: TextStyle(color: Colors.white, fontSize: 14),
                              ),
                              Spacer(),
                              Text(
                                widget.price, // Display price here
                                style: TextStyle(color: Colors.white, fontSize: 14),
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
                  Text(
                    'Overview',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.access_time, size: 20),
                          SizedBox(width: 4),
                          Text(widget.cookingTime), // Dynamic cookingTime
                        ],
                      ),
                      SizedBox(width: 16),
                      Row(
                        children: [
                          Icon(Icons.star, size: 20, color: Colors.amber),
                          SizedBox(width: 4),
                          Text('4.5'),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    widget.description,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentDetailPage(
                           recipeTitle: widget.recipeTitle, 
                           imageUrl: widget.imageUrl, 
                           price: widget.price,
                           location: widget.location,
                           difficulty: widget.difficulty,
                           cookingTime: widget.cookingTime,
                           description: widget.description,
                           mainIngredients: widget.mainIngredients, 
                            instructions: widget.instructions,
                      
              
                            ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Center(
                      child: Text(
                        'Purchase Recipe',
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




