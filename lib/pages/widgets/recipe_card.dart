import 'package:flutter/material.dart';

class RecipeCard extends StatelessWidget {
  final String title;
  final String location;
  final String image;
  final double rating;
  final VoidCallback onTap;
  final Widget trailing;

  const RecipeCard({
    required this.title,
    required this.location,
    required this.image,
    required this.rating,
    required this.onTap,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 120, // Berikan ukuran tetap untuk gambar
              width: 200,  // Berikan batasan lebar
              child: Image.asset(
                image,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        location,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  trailing,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}