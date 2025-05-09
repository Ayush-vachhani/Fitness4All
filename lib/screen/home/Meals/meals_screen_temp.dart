import 'dart:math';
import 'package:fitness4all/common/color_extensions.dart';
import 'package:fitness4all/screen/home/settings/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../notification/healthy_snack.dart';
import '../notification/food.dart';
import '../notification/compare.dart';
import 'response.dart';

class MealsScreenTem extends StatefulWidget {
  const MealsScreenTem({super.key});

  @override
  State<MealsScreenTem> createState() => _MealsScreenTemState();
}

class _MealsScreenTemState extends State<MealsScreenTem> {
  int _selectedIndex = 5;

  String _getRandomRecommendation(List<String> recommendations) {
    final random = Random();
    return recommendations[random.nextInt(recommendations.length)];
  }

  final List<String> _breakfastRecommendations = [
    "Oatmeal with fruits",
    "Avocado toast",
    "Scrambled eggs with spinach",
    "Greek yogurt with honey and nuts",
    "Smoothie bowl",
  ];

  final List<String> _lunchRecommendations = [
    "Grilled chicken salad",
    "Quinoa and vegetable stir-fry",
    "Turkey and avocado wrap",
    "Lentil soup with whole-grain bread",
    "Sushi rolls",
  ];

  final List<String> _snackRecommendations = [
    "Apple slices with peanut butter",
    "Trail mix",
    "Hummus with veggie sticks",
    "Dark chocolate and almonds",
    "Protein bar",
  ];

  final List<String> _dinnerRecommendations = [
    "Grilled salmon with asparagus",
    "Vegetable curry with brown rice",
    "Stuffed bell peppers",
    "Spaghetti squash with marinara sauce",
    "Chicken stir-fry with broccoli",
  ];

  // Controllers for text fields
  final TextEditingController _mealController = TextEditingController();
  final TextEditingController _templateController = TextEditingController();
  final TextEditingController _breakfastController = TextEditingController();
  final TextEditingController _lunchController = TextEditingController();
  final TextEditingController _dinnerController = TextEditingController();
  final TextEditingController _caloriesController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _waterController = TextEditingController();
  final TextEditingController _calorieLimitController = TextEditingController();
  final TextEditingController _selectedCategoryController = TextEditingController();
  final TextEditingController _unhealthyFoodController = TextEditingController();

  // State variables
  int _calories = 0;
  int _calorieLimit = 2000;
  int _waterIntake = 0;
  final List<Map<String, dynamic>> _savedMeals = [];
  final List<String> _waterLogs = [];
  List<String> _mealRecommendations = [];
  List<Map<String, dynamic>> _foodItems = []; // List to store food items from PocketBase
  Map<String, dynamic>? _foodComparison; // For nutritional comparisons

  final PocketBase pb = PocketBase('http://172.20.10.5:8090'); // Replace with your PocketBase URL

  final Map<int, Color> _pageColors = {
    0: Colors.green,
    1: Colors.orange,
    2: Colors.blue,
    3: Colors.red,
    4: Colors.purple,
    5: Colors.teal,
    6: Colors.indigo, // Meal Templates
    7: Colors.brown, // Daily Meal Plan
    8: Colors.amber, // Healthy Snack Options
    9: Colors.pink, // Nutritional Comparisons
    10: Colors.cyan, // Micronutrient Deficiencies
  };

  late final PageController _pageController;
  late final ScrollController _bottomNavScrollController;
  late List<Widget> _pages; // Declare _pages as late

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
    _bottomNavScrollController = ScrollController();
    _pages = _buildPages();
  }

  // Build pages for the PageView
  List<Widget> _buildPages() {
    return [
      _buildPage(
        "Add Meal",
        Icons.restaurant,
        "Add your meals and track nutrients.",
        SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: _mealController, decoration: const InputDecoration(labelText: "Enter meal name")),
              const SizedBox(height: 10),
              TextField(controller: _selectedCategoryController, decoration: const InputDecoration(labelText: "Enter Your Course")),
              const SizedBox(height: 10),
              TextField(controller: _caloriesController, decoration: const InputDecoration(labelText: "Enter calories"), keyboardType: TextInputType.number),
              const SizedBox(height: 10),
              TextField(controller: _notesController, decoration: const InputDecoration(labelText: "Add notes (optional)")),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  if (_mealController.text.isNotEmpty && _caloriesController.text.isNotEmpty) {
                    try {
                      final body = <String, dynamic>{
                        "MEAL": _mealController.text,
                        "COURSE": _selectedCategoryController.text,
                        "CALORIES": int.parse(_caloriesController.text),
                        "NOTES": _notesController.text,
                      };
                      await pb.collection('ADD_MEAL').create(body: body);
                      setState(() {
                        _savedMeals.add({
                          "name": _mealController.text,
                          "category": _selectedCategoryController.text,
                          "calories": int.parse(_caloriesController.text),
                          "notes": _notesController.text,
                          "date": DateTime.now(),
                        });
                      });
                      _mealController.clear();
                      _caloriesController.clear();
                      _notesController.clear();
                      _selectedCategoryController.clear();
                      _showSnackBar("Meal added successfully!");
                    } catch (e) {
                      _showSnackBar("Failed to save meal: $e", color: Colors.red);
                    }
                  } else {
                    _showSnackBar("Please fill in all required fields.", color: Colors.red);
                  }
                },
                child: const Text("Save Meal"),
              ),
              const SizedBox(height: 20),
              _savedMeals.isNotEmpty
                  ? ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _savedMeals.length,
                itemBuilder: (context, index) => _mealCard(_savedMeals[index]),
              )
                  : const Text("No meals saved yet."),
            ],
          ),
        ),
        _pageColors[0]!,
      ),
      _buildPage(
        "Set Calorie Limit",
        Icons.settings,
        "Manage your daily calorie goals.",
        SingleChildScrollView(
          child: Column(
            children: [
              Text("📏 Current Calorie Limit: $_calorieLimit kcal", style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 10),
              TextField(controller: _calorieLimitController, decoration: const InputDecoration(labelText: "Enter new limit"), keyboardType: TextInputType.number),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  if (_calorieLimitController.text.isNotEmpty) {
                    try {
                      if (int.parse(_calorieLimitController.text) > 2000) {
                        Fluttertoast.showToast(
                          msg: "Your calories exceeded your limit.",
                          toastLength: Toast.LENGTH_LONG, // Duration: LENGTH_SHORT (2s) or LENGTH_LONG (3.5s)
                          gravity: ToastGravity.BOTTOM, // Position of the toast
                          backgroundColor: Colors.orange, // Background color
                          textColor: Colors.white, // Text color
                        );
                      }
                      final body = <String, dynamic>{
                        "LIMIT": int.parse(_calorieLimitController.text),
                      };
                      await pb.collection('SET_LIMIT').create(body: body);
                      setState(() {
                        _calorieLimit = int.parse(_calorieLimitController.text);
                      });
                      _calorieLimitController.clear();
                      _showSnackBar("Calorie limit set successfully!");
                    } catch (e) {
                      _showSnackBar("Failed to set calorie limit: $e", color: Colors.red);
                    }
                  } else {
                    _showSnackBar("Please enter a valid limit.", color: Colors.red);
                  }
                },
                child: const Text("Update Limit"),
              ),
            ],
          ),
        ),
        _pageColors[3]!,
      ),
      _buildPage(
        "Water Intake",
        Icons.local_drink,
        "Track your daily water intake.",
        SingleChildScrollView(
          child: Column(
            children: [
              Text("💧 Total Water Intake: $_waterIntake ml", style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 10),
              TextField(controller: _waterController, decoration: const InputDecoration(labelText: "Enter water intake (ml)"), keyboardType: TextInputType.number),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  if (_waterController.text.isNotEmpty) {
                    try {
                      final body = <String, dynamic>{
                        "INTAKE": int.parse(_waterController.text),
                      };
                      await pb.collection('WATER_INTAKE').create(body: body);
                      setState(() {
                        _waterIntake += int.parse(_waterController.text);
                        _waterLogs.add("${_waterController.text} ml at ${DateTime.now()}");
                      });
                      _waterController.clear();
                      _showSnackBar("Water intake added successfully!");
                    } catch (e) {
                      _showSnackBar("Failed to save water intake: $e", color: Colors.red);
                    }
                  } else {
                    _showSnackBar("Please enter a valid amount.", color: Colors.red);
                  }
                },
                child: const Text("Add Water Intake"),
              ),
              const SizedBox(height: 20),
              if (_waterLogs.isNotEmpty)
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _waterLogs.length,
                  itemBuilder: (context, index) => ListTile(title: Text(_waterLogs[index])),
                )
              else
                const Text("No water intake logged yet."),
            ],
          ),
        ),
        _pageColors[2]!,
      ),
      _buildPage(
        "Meal & Snack Recommendations",
        Icons.recommend,
        "Get personalized meal suggestions.",
        SingleChildScrollView(
          child: Column(
            children: [
              Text("🍳 Breakfast: ${_getRandomRecommendation(_breakfastRecommendations)}"),
              const SizedBox(height: 10),
              Text("🍱 Lunch: ${_getRandomRecommendation(_lunchRecommendations)}"),
              const SizedBox(height: 10),
              Text("🍎 Snack: ${_getRandomRecommendation(_snackRecommendations)}"),
              const SizedBox(height: 10),
              Text("🍽 Dinner: ${_getRandomRecommendation(_dinnerRecommendations)}"),
              const SizedBox(height: 20),
            ],
          ),
        ),
        _pageColors[4]!,
      ),
      _buildPage(
        "Nutrient Breakdown",
        Icons.info,
        "View breakdown of nutrients.",
        SingleChildScrollView(
          child: Column(
            children: [
              if (FoodItems.foodList.isNotEmpty)
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: FoodItems.foodList.length,
                  itemBuilder: (context, index) {
                    final foodItem = FoodItems.foodList[index];
                    return ListTile(
                      title: Text(foodItem['name'] ?? 'No Name'),
                      subtitle: Text(
                        "Carbs: ${foodItem['carbs']}g, Proteins: ${foodItem['protein']}g, Fats: ${foodItem['fats']}g",
                      ),
                      trailing: Text(
                        "Deficiency: ${foodItem['deficiency']}",
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  },
                )
              else
                const Text("No food items found."),
            ],
          ),
        ),
        _pageColors[1]!,
      ),
      _buildPage(
        "Meal Templates",
        Icons.save,
        "Save your favorite meals as templates.",
        SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: _templateController, decoration: const InputDecoration(labelText: "Enter Template")),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  if (_templateController.text.isNotEmpty) {
                    try {
                      final body = <String, dynamic>{
                        "TEMPLATE": _templateController.text,
                      };
                      await pb.collection('TEMPLATE').create(body: body);
                      _templateController.clear();
                      _showSnackBar("Meal template saved successfully!");
                    } catch (e) {
                      _showSnackBar("Failed to save meal template: $e", color: Colors.red);
                    }
                  } else {
                    _showSnackBar("Please enter a valid template.", color: Colors.red);
                  }
                },
                child: const Text("Save Current Meal as Template"),
              ),
            ],
          ),
        ),
        _pageColors[2]!,
      ),
      _buildPage(
        "Daily Meal Plan",
        Icons.calendar_today,
        "View and customize your daily meal plan.",
        SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: _breakfastController, decoration: const InputDecoration(labelText: "Enter Breakfast")),
              const SizedBox(height: 10),
              TextField(controller: _lunchController, decoration: const InputDecoration(labelText: "Enter Lunch")),
              const SizedBox(height: 10),
              TextField(controller: _dinnerController, decoration: const InputDecoration(labelText: "Enter Dinner")),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  if (_breakfastController.text.isNotEmpty || _lunchController.text.isNotEmpty || _dinnerController.text.isNotEmpty) {
                    try {
                      final body = <String, dynamic>{
                        "BREAKFAST": _breakfastController.text,
                        "LUNCH": _lunchController.text,
                        "DINNER": _dinnerController.text,
                      };
                      await pb.collection('DAILY_MEAL').create(body: body);
                      _breakfastController.clear();
                      _lunchController.clear();
                      _dinnerController.clear();
                      _showSnackBar("Daily meal plan saved successfully!");
                    } catch (e) {
                      _showSnackBar("Failed to save daily meal plan: $e", color: Colors.red);
                    }
                  } else {
                    _showSnackBar("Please fill in at least one field.", color: Colors.red);
                  }
                },
                child: const Text("Customize Meal Plan"),
              ),
            ],
          ),
        ),
        _pageColors[3]!,
      ),
      _buildPage(
        "Healthy Snack Options",
        Icons.local_pizza,
        "Get healthier snack recommendations.",
        SingleChildScrollView(
          child: Column(
            children: [
              Text("1. ${HealthySnacks.getRandomSnack()}", style: const TextStyle(fontSize: 16)),
              Text("2. ${HealthySnacks.getRandomSnack()}", style: const TextStyle(fontSize: 16)),
              Text("3. ${HealthySnacks.getRandomSnack()}", style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
        _pageColors[4]!,
      ),
      _buildPage(
        "Nutritional Comparisons",
        Icons.compare_arrows,
        "Compare nutritional values of foods.",
        SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _unhealthyFoodController,
                decoration: const InputDecoration(labelText: "Enter Unhealthy Food Item"),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  final unhealthyFood = _unhealthyFoodController.text.trim();
                  if (unhealthyFood.isNotEmpty) {
                    // Fetch the comparison data from compare.dart
                    final comparison = FoodComparisons.unhealthyToHealthyMap[unhealthyFood];
                    if (comparison != null) {
                      // Navigate to the ResponseScreen with the comparison data
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ResponseScreen(comparison: comparison),
                        ),
                      );
                    } else {
                      // Show an error message if the food item is not found
                      _showSnackBar("No comparison found for this food item.", color: Colors.red);
                    }
                  } else {
                    // Show an error message if the input is empty
                    _showSnackBar("Please enter a food item.", color: Colors.red);
                  }
                },
                child: const Text("Compare"),
              ),
            ],
          ),
        ),
        _pageColors[5]!,
      ),
    ];
  }

  void _showSnackBar(String message, {Color color = Colors.green}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // Build a meal card widget
  Widget _mealCard(Map<String, dynamic> meal) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: const Icon(Icons.fastfood, size: 40, color: Colors.green),
        title: Text(meal["name"], style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("🍽 Category: ${meal["category"]}"),
            Text("🔥 ${meal["calories"]} kcal"),
            if (meal["notes"].isNotEmpty) Text("📝 Notes: ${meal["notes"]}"),
            Text("📅 ${meal["date"].toString().split('.')[0]}"),
          ],
        ),
      ),
    );
  }

  // Build a page widget
  Widget _buildPage(String title, IconData icon, String description, Widget child, Color color) {
    return Container(
      color: color.withOpacity(0.1),
      padding: const EdgeInsets.all(20),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, size: 80, color: color),
              const SizedBox(height: 20),
              Text(
                title,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
              ),
              const SizedBox(height: 10),
              Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: color.withOpacity(0.8)),
              ),
              const SizedBox(height: 20),
              child,
            ],
          ),
        ),
      ),
    );
  }

  // Handle bottom navigation bar item taps
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _bottomNavScrollController.animateTo(
        index * 80.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nutrition & Meal Tracker"),
        backgroundColor: _pageColors[_selectedIndex] ?? Colors.blue,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingScreen()));
            },
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: _pages,
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
        scrollController: _bottomNavScrollController,
      ),
    );
  }
}

// Custom bottom navigation bar widget
class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  final ScrollController scrollController;

  const CustomBottomNavBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
    required this.scrollController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      color: Colors.white,
      child: SingleChildScrollView(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.restaurant, "Meals", 0, Colors.green),
            _buildNavItem(Icons.settings, "Limits", 1, Colors.orange),
            _buildNavItem(Icons.local_drink, "Water", 2, Colors.blue),
            _buildNavItem(Icons.recommend, "Suggestions", 3, Colors.red),
            _buildNavItem(Icons.info, "Nutrients", 4, Colors.teal),
            _buildNavItem(Icons.save, "Templates", 5, Colors.indigo),
            _buildNavItem(Icons.calendar_today, "Meal Plan", 6, Colors.brown),
            _buildNavItem(Icons.local_pizza, "Snacks", 7, Colors.amber),
            _buildNavItem(Icons.compare_arrows, "Compare", 8, Colors.pink),
          ],
        ),
      ),
    );
  }

  // Build a navigation item widget
  Widget _buildNavItem(IconData icon, String label, int index, Color color) {
    return GestureDetector(
      onTap: () => onItemTapped(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                color: selectedIndex == index ? color : Colors.transparent,
                border: Border.all(
                  color: color,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                icon,
                size: 30,
                color: selectedIndex == index ? Colors.white : color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: selectedIndex == index ? Colors.black : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}