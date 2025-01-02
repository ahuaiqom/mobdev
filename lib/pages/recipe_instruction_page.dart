import 'package:flutter/material.dart';
import 'home_page.dart';
import 'history_page.dart';
import 'saved_recipe_page.dart';

class RecipeInstructionPage extends StatefulWidget {
  final String recipeTitle;
  final String location;
  final String difficulty;
  final String cookingTime;
  final String imageUrl;
  final List<String> mainIngredients;
  final List<String> instructions;
  final Function(String) onAddToHistory;

  const RecipeInstructionPage({
    required this.recipeTitle,
    required this.location,
    required this.difficulty,
    required this.cookingTime,
    required this.imageUrl,
    required this.mainIngredients,
    required this.instructions,
    required this.onAddToHistory,
    Key? key,
  }) : super(key: key);

  @override
  _RecipeInstructionPageState createState() => _RecipeInstructionPageState();
}

class _RecipeInstructionPageState extends State<RecipeInstructionPage> {
  int _currentIndex = 0;

  @override
void initState() {
  super.initState();
  // Tambahkan resep ke riwayat ketika halaman ini dibuka
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (widget.onAddToHistory != null) {
      widget.onAddToHistory({
        "title": widget.recipeTitle,
        "location": widget.location,
        "image": widget.imageUrl,
      } as String);
    }
  });
}

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HistoryPage(historyItems: [], onRemoveHistory: (String) {}, recipes: [],)),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SavedRecipePage(savedRecipes: [], onRemoveFavorite: (String) {}, historyItems: [], onRemoveHistory: (String) {},)),
        );
        break;
    }
  }

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
      body: Column(
        children: [
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.asset(
                  widget.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 16,
                right: 16,
                child: IconButton(
                  icon: Icon(Icons.favorite_border, color: Colors.white),
                  onPressed: () {
                    // Handle favorite action
                  },
                ),
              ),
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Card(
                  color: Colors.black.withOpacity(0.6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
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
                              'Difficulty: ${widget.difficulty}',
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
          Expanded(
            child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  TabBar(
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: Colors.black,
                    tabs: [
                      Tab(text: "Recipe"),
                      Tab(text: "Instruction"),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        // Recipe Tab
                        SingleChildScrollView(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Main Ingredients:',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              ...widget.mainIngredients.map(
                                (ingredient) => Padding(
                                  padding: const EdgeInsets.only(bottom: 4.0),
                                  child: Text(
                                    '- $ingredient',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Instruction Tab
                        SingleChildScrollView(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Steps:',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              ...widget.instructions.asMap().entries.map((entry) {
                                int index = entry.key + 1;
                                String step = entry.value;
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Text(
                                    '$index. $step',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Saved',
          ),
        ],
      ),
    );
  }
}
