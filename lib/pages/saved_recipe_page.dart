import 'package:flutter/material.dart';
import 'home_page.dart';
import 'history_page.dart'; // Import halaman HistoryPage

class SavedRecipePage extends StatefulWidget {
  final List<Map<String, dynamic>> savedRecipes;
  final Function(String) onRemoveFavorite;
  final List<Map<String, dynamic>> historyItems; // Tambahkan historyItems
  final Function(String) onRemoveHistory; // Tambahkan onRemoveHistory

  const SavedRecipePage({
    Key? key,
    required this.savedRecipes,
    required this.onRemoveFavorite,
    required this.historyItems, // Parameter baru
    required this.onRemoveHistory, // Parameter baru
  }) : super(key: key);

  @override
  _SavedRecipePageState createState() => _SavedRecipePageState();
}

class _SavedRecipePageState extends State<SavedRecipePage> {
  late TextEditingController searchController;
  late List<Map<String, dynamic>> filteredRecipes;
  List<String> categories = ["Favorites", "Paid Recipes", "Free Recipes"];
  int selectedCategoryIndex = 0;
  int _currentIndex = 2; // Default index for "Saved Recipes"

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    filteredRecipes = List.from(widget.savedRecipes);

    searchController.addListener(() {
      filterRecipes(searchController.text);
    });
  }

  void filterRecipes(String query) {
    setState(() {
      filteredRecipes = widget.savedRecipes.where((recipe) {
        final title = recipe["title"]?.toLowerCase() ?? '';
        final location = recipe["location"]?.toLowerCase() ?? '';
        final matchesSearch = title.contains(query.toLowerCase()) || location.contains(query.toLowerCase());
        final matchesCategory = (selectedCategoryIndex == 0 && recipe["isFavorite"] == true) ||
            (selectedCategoryIndex == 1 && recipe["isPaid"] == true) ||
            (selectedCategoryIndex == 2 && recipe["isPaid"] == false);
        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  void selectCategory(int index) {
    setState(() {
      selectedCategoryIndex = index;
      filterRecipes(searchController.text);
    });
  }

  void _onItemTapped(int index) {
    if (index == 0) {
      // Navigasi ke halaman Home
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else if (index == 1) {
      // Navigasi ke halaman History tanpa me-refresh bookmark
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HistoryPage(
            historyItems: widget.historyItems,
            onRemoveHistory: widget.onRemoveHistory,
            recipes: widget.savedRecipes, // Pastikan data bookmark tetap tersedia
          ),
        ),
      );
    } else {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Hilangkan back arrow
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'DapurKu',
          style: TextStyle(color: Colors.black, fontSize: 24),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: searchController,
              decoration: const InputDecoration(
                hintText: "Search Recipes",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final isSelected = index == selectedCategoryIndex;
                  return GestureDetector(
                    onTap: () => selectCategory(index),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        gradient: isSelected
                            ? const LinearGradient(colors: [Colors.blue, Colors.blueAccent])
                            : null,
                        color: isSelected ? null : Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          categories[index],
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: filteredRecipes.isEmpty
                  ? const Center(
                      child: Text(
                        "No saved recipes yet. Add some favorites!",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredRecipes.length,
                      itemBuilder: (context, index) {
                        final recipe = filteredRecipes[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            leading: Image.asset(
                              recipe["image"],
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                            title: Text(recipe["title"]),
                            subtitle: Text(recipe["location"]),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.favorite,
                                color: Colors.red,
                              ),
                              onPressed: () => widget.onRemoveFavorite(recipe["title"]),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
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
