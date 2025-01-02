import 'package:dapurku/pages/saved_recipe_page.dart';
import 'package:flutter/material.dart';
import 'widgets/search_bar.dart' as custom;
import 'widgets/recipe_card.dart';
import 'recipe_detail_page.dart';
import 'history_page.dart';
import 'saved_recipe_page.dart';
import 'paid_recipe.dart';
import 'package:provider/provider.dart';
import 'recipe_provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, dynamic>> recipes = [
    {
      "title": "Rendang",
    "location": "Padang, Indonesia",
    "rating": 4.8,
    "image": "lib/images/rendang.jpg",
    "description": "A rich and tender coconut beef stew.",
    "cookingTime": "3 hours",
    "isFavorite": false,
    "isPaid": false,
    "ingredients": ["Beef", "Coconut milk", "Spices"],
    "instructions": ["Cut beef", "Cook with spices", "Simmer"],
    "difficulty": "Hard",
  },
  {
    "title": "Gulai",
    "location": "Java, Indonesia",
    "rating": 4.7,
    "image": "lib/images/gulai.jpg",
    "description": "Spicy and savory Indonesian curry.",
    "cookingTime": "1.5 hours",
    "isFavorite": false,
    "isPaid": false,
    "ingredients": ["Meat", "Coconut milk", "Spices"],
    "instructions": ["Prepare meat", "Cook curry", "Serve hot"],
    "difficulty": "Medium",
  },
  {
    "title": "Nasi Goreng Udang",
    "location": "Bandung, Indonesia",
    "rating": 4.5,
    "image": "lib/images/udang.jpg",
    "description": "Delicious fried rice with shrimp.",
    "cookingTime": "30 minutes",
    "isFavorite": false,
    "isPaid": false,
    "ingredients": ["Rice", "Shrimp", "Soy sauce"],
    "instructions": ["Cook shrimp", "Fry rice with spices", "Serve hot"],
    "difficulty": "Easy",
  },
  {
    "title": "Nasi Lemak",
    "location": "Malaysia",
    "rating": 4.8,
    "image": "lib/images/nasilemak.jpg",
    "description": "Fragrant coconut rice with sides.",
    "cookingTime": "1 hour",
    "isFavorite": false,
    "isPaid": false,
    "ingredients": ["Rice", "Coconut milk", "Anchovies", "Egg"],
    "instructions": ["Cook rice in coconut milk", "Prepare sides", "Serve with sambal"],
    "difficulty": "Medium",
  },
  {
    "title": "Nasi Krawu",
    "location": "Surabaya, Indonesia",
    "rating": 4.6,
    "image": "lib/images/krawu.jpg",
    "description": "Savory shredded beef with rice.",
    "cookingTime": "2 hours",
    "isFavorite": false,
    "isPaid": true,
    "price": "MYR 10",
    "ingredients": ["Beef", "Rice", "Coconut"],
    "instructions": ["Cook beef", "Prepare rice", "Serve with sambal"],
    "difficulty": "Medium",
  },
  {
    "title": "Tom Yum",
    "location": "Thailand",
    "rating": 4.9,
    "image": "lib/images/tomyum.jpg",
    "description": "Spicy and sour Thai soup.",
    "cookingTime": "45 minutes",
    "isFavorite": false,
    "isPaid": true,
    "price": "MYR 15",
    "ingredients": ["Shrimp", "Lemongrass", "Lime", "Chili"],
    "instructions": ["Boil broth", "Add ingredients", "Simmer until cooked"],
    "difficulty": "Medium",
    },
  ];
  
  List<Map<String, dynamic>> historyItems = []; // Untuk menyimpan riwayat
  List<Map<String, dynamic>> filteredRecipes = [];
  List<Map<String, dynamic>> savedRecipes = []; // Added savedRecipes
  TextEditingController searchController = TextEditingController();
  List<String> categories = ["Most Viewed", "Indonesian", "Malaysian", "Thai"];
  int selectedCategoryIndex = 0;

  @override
  void initState() {
    super.initState();
    filteredRecipes = recipes;
  }

  void filterRecipes(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredRecipes = recipes;
      } else {
        filteredRecipes = recipes
            .where((recipe) =>
                recipe["title"]!.toLowerCase().contains(query.toLowerCase()) ||
                recipe["location"]!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

   void toggleFavorite(int index) {
    setState(() {
      recipes[index]["isFavorite"] = !recipes[index]["isFavorite"];
      if (recipes[index]["isFavorite"]) {
        savedRecipes.add(recipes[index]);
      } else {
        savedRecipes.removeWhere((recipe) =>
            recipe["title"] == recipes[index]["title"]);
      }
    });
  }

  void selectCategory(int index) {
    setState(() {
      selectedCategoryIndex = index;
      if (categories[index] == "Indonesian") {
        filteredRecipes = recipes.where((recipe) => recipe["location"]?.contains("Indonesia") ?? false).toList();
      } else if (categories[index] == "Malaysian") {
        filteredRecipes = recipes.where((recipe) => recipe["location"]?.contains("Malaysia") ?? false).toList();
      } else if (categories[index] == "Thai") {
        filteredRecipes = recipes.where((recipe) => recipe["location"]?.contains("Thailand") ?? false).toList();
      } else {
        filteredRecipes = recipes;
      }
    });
  }

 
  int _currentIndex = 0;

   void _onItemTapped(int index) async {
  if (index == 1) { // Navigasi ke HistoryPage
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HistoryPage(
          recipes: recipes,
          historyItems: [], // Sesuaikan jika ada data history
          onRemoveHistory: (String) {}, // Sesuaikan jika perlu fungsi penghapusan
        ),
      ),
    );
    // Setelah kembali dari HistoryPage, sinkronkan data favorit
    setState(() {
      for (var recipe in recipes) {
        recipe["isFavorite"] = savedRecipes.any((saved) => saved["title"] == recipe["title"]);
      }
    });
  } else if (index == 2) { // Navigasi ke SavedRecipePage
    final updatedRecipes = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SavedRecipePage(
          savedRecipes: savedRecipes,
          onRemoveFavorite: (title) {
            setState(() {
              recipes.firstWhere((recipe) => recipe["title"] == title)["isFavorite"] = false;
              savedRecipes.removeWhere((recipe) => recipe["title"] == title);
            });
          }, historyItems: [], onRemoveHistory: (String ) {  },
        ),
      ),
    );

    if (updatedRecipes != null) {
      setState(() {
        savedRecipes = updatedRecipes;
        for (var recipe in recipes) {
          recipe["isFavorite"] = savedRecipes.any((saved) => saved["title"] == recipe["title"]);
        }
      });
    }
  } else {
    setState(() {
      _currentIndex = index;
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'DapurKu',
          style: TextStyle(color: Colors.black, fontSize: 24),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.green,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                "Hi, Ahua!",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: searchController,
                onChanged: filterRecipes,
                decoration: InputDecoration(
                  hintText: "Search Recipes",
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      searchController.clear();
                      filterRecipes('');
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              SizedBox(height: 16),
              Text(
                "Popular Recipes",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(categories.length, (index) {
                    bool isSelected = selectedCategoryIndex == index;
                    return GestureDetector(
                      onTap: () => selectCategory(index),
                      child: Container(
                        margin: EdgeInsets.only(right: 8),
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          gradient: isSelected
                              ? LinearGradient(colors: [Colors.blue, Colors.blueAccent])
                              : null,
                          color: isSelected ? null : Colors.grey[300],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          categories[index],
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredRecipes.length,
                  itemBuilder: (context, index) {
                    final recipe = filteredRecipes[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              if (recipe["isPaid"] == true) {
                                return PaidRecipeDetailPage(
                                  recipeTitle: recipe["title"],
                                  description: recipe["description"],
                                  imageUrl: recipe["image"],
                                  location: recipe["location"],
                                  cookingTime: recipe["cookingTime"],
                                  price: recipe["price"],
                                  difficulty: recipe["difficulty"],    
                                  mainIngredients: recipe["ingredients"],
                                  instructions: recipe["instructions"],                              
                                );
                              } else {
                                return RecipeDetailPage(
                                recipeTitle: recipe["title"],
                                description: recipe["description"],
                                imageUrl: recipe["image"],
                                location: recipe["location"],
                                cookingTime: recipe["cookingTime"],
                                difficulty: recipe["difficulty"],
                                mainIngredients: recipe["ingredients"],
                                instructions: recipe["instructions"],
                                 onAddToHistory: (recipe) => onAddToHistory(recipe as Map<String, dynamic>),

                                );
                              }
                            },
                          ),
                        );
                      },
                      child: Card(
                        margin: EdgeInsets.symmetric(vertical: 8),
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
                            icon: Icon(
                              recipe["isFavorite"]
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: recipe["isFavorite"] ? Colors.red : Colors.grey,
                            ),
                            onPressed: () => toggleFavorite(index),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
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
  }void onAddToHistory(Map<String, dynamic> recipe) {
    setState(() {
      historyItems.add(recipe);
    });
  }
}