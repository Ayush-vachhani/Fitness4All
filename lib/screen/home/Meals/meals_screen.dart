import 'package:flutter/material.dart';

class MealsScreen extends StatefulWidget {
  const MealsScreen({super.key});

  @override
  State<MealsScreen> createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen> {
  int _selectedIndex = 0;
  final TextEditingController _mealController = TextEditingController();
  final TextEditingController _caloriesController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _waterController = TextEditingController();
  final TextEditingController _calorieLimitController = TextEditingController();

  int _calories = 0;
  int _calorieLimit = 2000;
  int _waterIntake = 0;
  final List<Map<String, dynamic>> _savedMeals = [];
  final List<String> _waterLogs = [];
  final List<String> _mealRecommendations = [
    "🥗 Salad with Grilled Chicken",
    "🍳 Scrambled Eggs with Avocado Toast",
    "🍲 Lentil Soup with Whole Grain Bread",
    "🥑 Greek Yogurt with Berries & Nuts",
    "🥜 Peanut Butter Banana Smoothie"
  ];

  final Map<int, Color> _pageColors = {
    0: Colors.green,
    1: Colors.orange,
    2: Colors.blue,
    3: Colors.red,
    4: Colors.purple,
    5: Colors.teal,
    6: Colors.indigo,  // Meal Templates
    7: Colors.brown,   // Daily Meal Plan
    8: Colors.amber,   // Healthy Snack Options
    9: Colors.pink,    // Nutritional Comparisons
    10: Colors.cyan,   // Micronutrient Deficiencies
  };

  final List<String> _mealCategories = ["Breakfast", "Lunch", "Dinner", "Snack"];
  String _selectedCategory = "Lunch";

  void _showSnackBar(String message, {Color color = Colors.green}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 3), // Increased duration
      ),
    );
  }

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

  Widget _buildPage(String title, IconData icon, String description, Widget child, Color color) {
    return Container(
      color: color.withOpacity(0.1),
      padding: const EdgeInsets.all(20),
      child: Center(
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
    );
  }

  late final List<Widget> _pages;
  late final PageController _pageController;
  late final ScrollController _bottomNavScrollController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
    _bottomNavScrollController = ScrollController();
    _pages = [
      _buildPage(
        "Add Meal",
        Icons.restaurant,
        "Add your meals and track nutrients.",
        Column(
          children: [
            TextField(controller: _mealController, decoration: const InputDecoration(labelText: "Enter meal name")),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: _selectedCategory,
              items: _mealCategories.map((String category) {
                return DropdownMenuItem(value: category, child: Text(category));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                });
              },
            ),
            const SizedBox(height: 10),
            TextField(controller: _caloriesController, decoration: const InputDecoration(labelText: "Enter calories"), keyboardType: TextInputType.number),
            const SizedBox(height: 10),
            TextField(controller: _notesController, decoration: const InputDecoration(labelText: "Add notes (optional)")),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                if (_mealController.text.isNotEmpty && _caloriesController.text.isNotEmpty) {
                  setState(() {
                    int mealCalories = int.parse(_caloriesController.text);
                    _calories += mealCalories; // Update total calories
                    _savedMeals.add({
                      "name": _mealController.text,
                      "category": _selectedCategory,
                      "calories": mealCalories,
                      "notes": _notesController.text,
                      "date": DateTime.now(),
                    });
                    _mealController.clear();
                    _caloriesController.clear();
                    _notesController.clear();
                  });
                  _showSnackBar("Meal added successfully!");
                } else {
                  _showSnackBar("Please fill in all fields.", color: Colors.red);
                }
              },
              child: const Text("Save Meal"),
            ),
            const SizedBox(height: 20),
            _savedMeals.isNotEmpty
                ? Expanded(
              child: ListView.builder(
                itemCount: _savedMeals.length,
                itemBuilder: (context, index) => _mealCard(_savedMeals[index]),
              ),
            )
                : const Text("No meals saved yet."),
          ],
        ),
        _pageColors[0]!,
      ),
      _buildPage(
        "Set Calorie Limit",
        Icons.settings,
        "Manage your daily calorie goals.",
        Column(
          children: [
            Text("📏 Current Calorie Limit: $_calorieLimit kcal", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            TextField(controller: _calorieLimitController, decoration: const InputDecoration(labelText: "Enter new limit"), keyboardType: TextInputType.number),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                if (_calorieLimitController.text.isNotEmpty) {
                  setState(() {
                    _calorieLimit = int.parse(_calorieLimitController.text);
                    _calorieLimitController.clear();
                  });
                  _showSnackBar("Calorie limit set successfully!");
                } else {
                  _showSnackBar("Please enter a valid limit.", color: Colors.red);
                }
              },
              child: const Text("Update Limit"),
            ),
          ],
        ),
        _pageColors[3]!,
      ),
      _buildPage(
        "Water Intake",
        Icons.local_drink,
        "Track your daily water intake.",
        Column(
          children: [
            Text("💧 Total Water Intake: $_waterIntake ml", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            TextField(controller: _waterController, decoration: const InputDecoration(labelText: "Enter water intake (ml)"), keyboardType: TextInputType.number),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                if (_waterController.text.isNotEmpty) {
                  setState(() {
                    _waterIntake += int.parse(_waterController.text);
                    _waterLogs.add("${_waterController.text} ml at ${DateTime.now()}");
                    _waterController.clear();
                  });
                  _showSnackBar("Water intake added successfully!");
                } else {
                  _showSnackBar("Please enter a valid amount.", color: Colors.red);
                }
              },
              child: const Text("Add Water Intake"),
            ),
            const SizedBox(height: 20),
            if (_waterLogs.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: _waterLogs.length,
                  itemBuilder: (context, index) => ListTile(title: Text(_waterLogs[index])),
                ),
              )
            else
              const Text("No water intake logged yet."),
          ],
        ),
        _pageColors[2]!,
      ),
      _buildPage(
        "Meal & Snack Recommendations",
        Icons.recommend,
        "Get personalized meal suggestions.",
        Column(
          children: _mealRecommendations.map((meal) => Text(meal, style: const TextStyle(fontSize: 16))).toList(),
        ),
        _pageColors[4]!,
      ),
      _buildPage(
        "Calorie Tracker",
        Icons.track_changes,
        "Track your total calorie intake.",
        Column(
          children: [
            Text("🔥 Total Calories Consumed: $_calories kcal", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _calories = 0; // Reset calories if needed
                });
                _showSnackBar("Calories reset!", color: Colors.red);
              },
              child: const Text("Reset Calories"),
            ),
          ],
        ),
        _pageColors[5]!,
      ),
      _buildPage(
        "Nutrient Breakdown",
        Icons.info,
        "View breakdown of nutrients.",
        Column(
          children: [
            Text("Carbs: 250g", style: const TextStyle(fontSize: 16)),
            Text("Proteins: 150g", style: const TextStyle(fontSize: 16)),
            Text("Fats: 70g", style: const TextStyle(fontSize: 16)),
          ],
        ),
        _pageColors[1]!,
      ),
      _buildPage(
        "Meal Templates",
        Icons.save,
        "Save your favorite meals as templates.",
        Column(
          children: [
            Text("1. Chicken Stir Fry", style: const TextStyle(fontSize: 16)),
            Text("2. Veggie Wrap", style: const TextStyle(fontSize: 16)),
            Text("3. Smoothie Bowl", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: () {}, child: const Text("Save Current Meal as Template")),
          ],
        ),
        _pageColors[2]!,
      ),
      _buildPage(
        "Daily Meal Plan",
        Icons.calendar_today,
        "View and customize your daily meal plan.",
        Column(
          children: [
            Text("Breakfast: Oatmeal with Fruits", style: const TextStyle(fontSize: 16)),
            Text("Lunch: Grilled Chicken Salad", style: const TextStyle(fontSize: 16)),
            Text("Dinner: Quinoa and Vegetables", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: () {}, child: const Text("Customize Meal Plan")),
          ],
        ),
        _pageColors[3]!,
      ),
      _buildPage(
        "Healthy Snack Options",
        Icons.local_pizza,
        "Get healthier snack recommendations.",
        Column(
          children: [
            Text("1. Greek Yogurt with Honey", style: const TextStyle(fontSize: 16)),
            Text("2. Hummus with Veggies", style: const TextStyle(fontSize: 16)),
            Text("3. Mixed Nuts", style: const TextStyle(fontSize: 16)),
          ],
        ),
        _pageColors[4]!,
      ),
      _buildPage(
        "Nutritional Comparisons",
        Icons.compare_arrows,
        "Compare nutritional values of foods.",
        Column(
          children: [
            Text("Chips: 150 kcal, 10g fat", style: const TextStyle(fontSize: 16)),
            Text("Veggie Sticks: 50 kcal, 0g fat", style: const TextStyle(fontSize: 16)),
          ],
        ),
        _pageColors[5]!,
      ),
      _buildPage(
        "Micronutrient Deficiencies",
        Icons.warning,
        "Highlight deficiencies and suggest adjustments.",
        Column(
          children: [
            Text("Deficiency in Vitamin D:", style: const TextStyle(fontSize: 16)),
            Text("Consider adding more fatty fish or fortified foods.", style: const TextStyle(fontSize: 16)),
          ],
        ),
        _pageColors[1]!,
      ),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      // Scroll the bottom navigation bar to the selected index
      _bottomNavScrollController.animateTo(
        index * 80.0, // Adjust this value based on your item width
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _mealController.dispose();
    _caloriesController.dispose();
    _notesController.dispose();
    _waterController.dispose();
    _calorieLimitController.dispose();
    _pageController.dispose();
    _bottomNavScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nutrition & Meal Tracker"),
        backgroundColor: _pageColors[_selectedIndex] ?? Colors.blue, // Ensure a default color
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Add your settings functionality here
              _showSnackBar("Settings clicked!");
            },
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
            // Scroll the bottom navigation bar to the selected index
            _bottomNavScrollController.animateTo(
              index * 80.0, // Adjust this value based on your item width
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
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
      height: 80, // Increased height for the bottom navigation bar
      color: Colors.white, // Set the background color to white
      child: SingleChildScrollView(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.restaurant, "Meals", 0, Colors.green),
            _buildNavItem(Icons.settings, "Limits", 1, Colors.orange),
            _buildNavItem(Icons.local_drink, "Water", 2, Colors.blue),
            _buildNavItem(Icons.track_changes, "Calories", 3, Colors.red),
            _buildNavItem(Icons.recommend, "Suggestions", 4, Colors.purple),
            _buildNavItem(Icons.info, "Nutrients", 5, Colors.teal),
            _buildNavItem(Icons.save, "Templates", 6, Colors.indigo), // Meal Templates
            _buildNavItem(Icons.calendar_today, "Meal Plan", 7, Colors.brown), // Daily Meal Plan
            _buildNavItem(Icons.local_pizza, "Snacks", 8, Colors.amber), // Healthy Snack Options
            _buildNavItem(Icons.compare_arrows, "Compare", 9, Colors.pink), // Nutritional Comparisons
            _buildNavItem(Icons.warning, "Deficiencies", 10, Colors.cyan), // Micronutrient Deficiencies
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index, Color color) {
    return GestureDetector(
      onTap: () => onItemTapped(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10), // Increased vertical padding
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
                size: 30, // Increased icon size
                color: selectedIndex == index ? Colors.white : color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 14, // Increased font size
                color: selectedIndex == index ? Colors.black : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}