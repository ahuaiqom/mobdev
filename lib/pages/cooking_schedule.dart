import 'package:flutter/material.dart';

class CookingSchedulePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cooking Schedule'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Text(
          'Cooking Schedule Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
