import 'package:flutter/material.dart';
import 'home_page.dart';
import 'saved_recipe_page.dart'; // Tambahkan import untuk halaman SavedRecipePage

class HistoryPage extends StatefulWidget {
  final List<Map<String, dynamic>> historyItems;
  final Function(String) onRemoveHistory;

  const HistoryPage({
    Key? key,
    required this.historyItems,
    required this.onRemoveHistory, 
    required List<Map<String, dynamic>> recipes,
  }) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late TextEditingController searchController;
  late List<Map<String, dynamic>> filteredHistory;
  List<String> categories = ["All", "Viewed", "Purchased"];
  int selectedCategoryIndex = 0;
  int _currentIndex = 1; // Default index for "History"

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    filteredHistory = List.from(widget.historyItems);

    searchController.addListener(() {
      filterHistory(searchController.text);
    });
  }

  void filterHistory(String query) {
    setState(() {
      filteredHistory = widget.historyItems.where((item) {
        final title = item["title"]?.toLowerCase() ?? '';
        final location = item["location"]?.toLowerCase() ?? '';
        final matchesSearch = title.contains(query.toLowerCase()) || location.contains(query.toLowerCase());
        final matchesCategory = (selectedCategoryIndex == 0) ||
            (selectedCategoryIndex == 1 && item["isViewed"] == true) ||
            (selectedCategoryIndex == 2 && item["isPurchased"] == true);
        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  void selectCategory(int index) {
    setState(() {
      selectedCategoryIndex = index;
      filterHistory(searchController.text);
    });
  }

  void _onItemTapped(int index) {
    if (index == 0) {
      // Navigasi ke halaman Home
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else if (index == 2) {
      // Navigasi ke halaman SavedRecipePage
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SavedRecipePage(savedRecipes: [], onRemoveFavorite: (String ) {  }, historyItems: [], onRemoveHistory: (String ) {  },)),
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
                hintText: "Search History",
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
              child: filteredHistory.isEmpty
                  ? const Center(
                      child: Text(
                        "No history yet. Start exploring!",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredHistory.length,
                      itemBuilder: (context, index) {
                        final item = filteredHistory[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            leading: Image.asset(
                              item["image"],
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                            title: Text(item["title"]),
                            subtitle: Text(item["location"]),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () => widget.onRemoveHistory(item["title"]),
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
