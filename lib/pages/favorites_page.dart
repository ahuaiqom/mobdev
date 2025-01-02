import 'package:flutter/material.dart';

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: Text(
          'Favorites Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
