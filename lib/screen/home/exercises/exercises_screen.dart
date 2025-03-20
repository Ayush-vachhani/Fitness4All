import 'package:fitness4all/common/color_extensions.dart';
import 'package:fitness4all/screen/home/settings/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart'; // Add this import

class ExerciseScreen extends StatefulWidget {
  const ExerciseScreen({super.key});

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  int _selectedIndex = 0;
  final TextEditingController _exerciseController = TextEditingController();
  final TextEditingController _caloriesController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _timerController = TextEditingController();
  final TextEditingController _MorningController = TextEditingController();
  final TextEditingController _EveningController = TextEditingController();
  final TextEditingController _AfternoonController = TextEditingController();


  void _startTimer() {
    setState(() {
      _isTimerRunning = true; // Set the timer state to running
      _startTime = DateTime.now(); // Record the start time
      print("Timer started at: $_startTime");
    });
  }

  void _stopTimer() {
    setState(() {
      _isTimerRunning = false; // Set the timer state to stopped
      _endTime = DateTime.now(); // Record the end time

      if (_startTime != null && _endTime != null) {
        // Calculate the time difference in seconds
        _timeDifference = _endTime!.difference(_startTime!).inSeconds;

        // Update total time spent (accumulate previous time differences)
        _totalTimeSpent += _timeDifference;

        // Calculate calories burned (time difference * 0.017)
        double caloriesBurned = _timeDifference * 0.017;

        // Update total calories burned (accumulate previous calories burned)
        _totalCaloriesBurned += caloriesBurned.round(); // Round to the nearest integer

        // Show a snackbar with the results
        _showSnackBar(
          "Timer stopped! Time spent: $_timeDifference seconds, Calories burned: ${caloriesBurned.toStringAsFixed(2)} kcal",
        );

        // Debugging: Print the updated values
        print("Total Calories Burned: $_totalCaloriesBurned");
        print("Total Time Spent: $_totalTimeSpent");
      }
    });
  }

  // Local variables to store exercise data
  // Local variables to store exercise data
  int _totalCaloriesBurned = 0;
  int _totalTimeSpent = 0; // Time spent in seconds
  final List<Map<String, dynamic>> _savedExercises = [];
  final List<String> _exerciseRecommendations = [
    "🏋‍♂ Weightlifting",
    "🏃‍♂ Running",
    "🚴‍♂ Cycling",
    "🧘‍♀ Yoga",
    "🏊‍♂ Swimming",
    "🤸‍♀ Pilates",
    "🥊 Boxing",
    "🤼‍♂ Wrestling"
  ];

  // Timer-related variables
  bool _isTimerRunning = false; // Tracks if the timer is running
  DateTime? _startTime; // Stores the start time of the timer
  DateTime? _endTime; // Stores the end time of the timer
  int _timeDifference = 0; // Stores the

  final Map<int, Color> _pageColors = {
    0: Colors.green,
    1: Colors.orange,
    2: Colors.blue,
    3: Colors.red,
    4: Colors.purple,
    5: Colors.teal,
  };


  final List<String> _exerciseCategories = ["Cardio", "Strength", "Flexibility", "Endurance"];
  String _selectedCategory = "Cardio";

  // Initialize PocketBase
  final pb = PocketBase('http://192.168.94.20:8090');

  void _showSnackBar(String message, {Color color = Colors.green}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Widget _exerciseCard(Map<String, dynamic> exercise) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: const Icon(Icons.fitness_center, size: 40, color: Colors.green),
        title: Text(exercise["name"], style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("🏋‍♂ Category: ${exercise["category"]}"),
            Text("🔥 ${exercise["calories"]} kcal burned"),
            if (exercise["notes"].isNotEmpty) Text("📝 Notes: ${exercise["notes"]}"),
            Text("⏱ Time Spent: ${exercise["time"]} minutes"),
            Text("📅 ${exercise["date"].toString().split('.')[0]}"),
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
        "Add Exercise",
        Icons.fitness_center,
        "Log your exercises and track calories burned.",
        Column(
          children: [
            TextField(controller: _exerciseController, decoration: const InputDecoration(labelText: "Enter exercise name")),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: _selectedCategory,
              items: _exerciseCategories.map((String category) {
                return DropdownMenuItem(value: category, child: Text(category));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                });
              },
            ),
            const SizedBox(height: 10),
            TextField(controller: _caloriesController, decoration: const InputDecoration(labelText: "Enter calories burned"), keyboardType: TextInputType.number),
            const SizedBox(height: 10),
            TextField(controller: _timeController, decoration: const InputDecoration(labelText: "Enter time spent (minutes)"), keyboardType: TextInputType.number),
            const SizedBox(height: 10),
            TextField(controller: _notesController, decoration: const InputDecoration(labelText: "Add notes (optional)")),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                if (_exerciseController.text.isNotEmpty && _caloriesController.text.isNotEmpty && _timeController.text.isNotEmpty) {
                  try {
                    // Create the body for the PocketBase record
                    final body = <String, dynamic>{
                      "name": _exerciseController.text,
                      "notes": _notesController.text,
                      "calories_burned": int.parse(_caloriesController.text),
                      "time_spent": _timeController.text,
                    };

                    // Create the record in PocketBase
                    final record = await pb.collection('ExerciseMain').create(body: body);

                    // Update the local state
                    setState(() {
                      int exerciseCalories = int.parse(_caloriesController.text);
                      int exerciseTime = int.parse(_timeController.text);
                      _totalCaloriesBurned += exerciseCalories;
                      _totalTimeSpent += exerciseTime;
                      _savedExercises.add({
                        "name": _exerciseController.text,
                        "category": _selectedCategory,
                        "calories": exerciseCalories,
                        "time": exerciseTime,
                        "notes": _notesController.text,
                        "date": DateTime.now(),
                      });
                      _exerciseController.clear();
                      _caloriesController.clear();
                      _timeController.clear();
                      _notesController.clear();
                    });

                    _showSnackBar("Exercise logged successfully!");
                  } catch (e) {
                    _showSnackBar("Failed to log exercise: $e", color: Colors.red);
                  }
                } else {
                  _showSnackBar("Please fill in all fields.", color: Colors.red);
                }
              },
              child: const Text("Log Exercise"),
            ),
            const SizedBox(height: 20),
            _savedExercises.isNotEmpty
                ? Expanded(
              child: ListView.builder(
                itemCount: _savedExercises.length,
                itemBuilder: (context, index) => _exerciseCard(_savedExercises[index]),
              ),
            )
                : const Text("No exercises logged yet."),
          ],
        ),
        _pageColors[0]!,
      ),
      _buildPage(
        "Time to Calories",
        Icons.timer,
        "Track calories burned based on time spent.",
        Column(
          children: [
            Text(
              "🔥 Total Calories Burned are logged below ",
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              "⏱ Total Time Spent are logged below",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                if (_isTimerRunning) {
                  _stopTimer();
                } else {
                  _startTimer();
                }
              },
              child: Text(_isTimerRunning ? "Stop" : "Click here"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _totalCaloriesBurned = 0;
                  _totalTimeSpent = 0;
                });
                _showSnackBar("Calories and time reset!", color: Colors.red);
              },
              child: const Text("Reset Data"),
            ),
          ],
        ),
        _pageColors[1]!,
      ),


      _buildPage(
        "Exercise Recommendations",
        Icons.recommend,
        "Get personalized exercise suggestions.",
        Column(
          children: _exerciseRecommendations.map((exercise) => Text(exercise, style: const TextStyle(fontSize: 16))).toList(),
        ),
        _pageColors[2]!,
      ),
      _buildPage(
        "Time Setter",
        Icons.timer,
        "Set and log your exercise time frame.",
        Column(
          children: [
            Text("⏱ Total Time Spent will be logged upon tryping", style: const TextStyle(fontSize: 15)),
            const SizedBox(height: 10),
            TextField(controller: _timerController, decoration: const InputDecoration(labelText: "Enter time spent (minutes)"), keyboardType: TextInputType.number),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                if (_timerController.text.isNotEmpty) {
                  try {
                    // Create the body for the PocketBase record
                    final body = <String, dynamic>{
                      "Time": int.parse(_timerController.text), // Convert the input to an integer
                    };

                    // Create the record in PocketBase
                    final record = await pb.collection('TimeSetter').create(body: body);

                    // Update the local state
                    setState(() {
                      _totalTimeSpent += int.parse(_timerController.text);
                      _timerController.clear();
                    });

                    // Show a success message
                    _showSnackBar("Time logged successfully!");
                  } catch (e) {
                    // Show an error message if something goes wrong
                    _showSnackBar("Failed to log time: $e", color: Colors.red);
                  }
                } else {
                  // Show a message if the field is empty
                  _showSnackBar("Please enter a valid time.", color: Colors.red);
                }
              },
              child: const Text("Log Time"),
            ),
          ],
        ),
        _pageColors[3]!,
      ),
      _buildPage(
        "Exercise Templates",
        Icons.save,
        "Save your favorite exercises as templates.",
        Column(
          children: [
            Text("1. Push-ups", style: const TextStyle(fontSize: 16)),
            Text("2. Squats", style: const TextStyle(fontSize: 16)),
            Text("3. Plank", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: () {}, child: const Text("Save Current Exercise as Template")),
          ],
        ),
        _pageColors[4]!,
      ),
      _buildPage(
        "Daily Exercise Plan",
        Icons.calendar_today,
        "View and customize your daily exercise plan.",
        Column(
          children: [
            TextField(controller: _MorningController, decoration: const InputDecoration(labelText: "Add your morning plan")),
            const SizedBox(height: 10),
            TextField(controller: _EveningController, decoration: const InputDecoration(labelText: "Add your afternoon plan")),
            const SizedBox(height: 10),
            TextField(controller: _AfternoonController, decoration: const InputDecoration(labelText: "Add your evening plan")),
            const SizedBox(height: 10),


            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                if (_MorningController.text.isNotEmpty || _AfternoonController.text.isNotEmpty || _EveningController.text.isNotEmpty) {
                  try {
                    // Create the body for the PocketBase record
                    final body = <String, dynamic>{
                      "morning": _MorningController.text,
                      "afternoon": _AfternoonController.text,
                      "evening": _EveningController.text,
                      "day": "test", // Keep day as "test" as per your requirement
                    };

                    // Create the record in PocketBase
                    final record = await pb.collection('DailyExercisePlan').create(body: body);

                    // Show a success message
                    _showSnackBar("Daily exercise plan saved successfully!");
                  } catch (e) {
                    // Show an error message if something goes wrong
                    _showSnackBar("Failed to save daily exercise plan: $e", color: Colors.red);
                  }
                } else {
                  // Show a message if all fields are empty
                  _showSnackBar("Please fill in at least one field.", color: Colors.red);
                }
              },
              child: const Text("Customize Plan"),
            ),
          ],
        ),
        _pageColors[5]!,
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
      _bottomNavScrollController.animateTo(
        index * 80.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _exerciseController.dispose();
    _caloriesController.dispose();
    _notesController.dispose();
    _timeController.dispose();
    _pageController.dispose();
    _bottomNavScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Exercise Tracker"),
        backgroundColor: _pageColors[_selectedIndex] ?? Colors.blue,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              context.push(const SettingScreen());
            },
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
            _bottomNavScrollController.animateTo(
              index * 80.0,
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
      height: 80,
      color: Colors.white,
      child: SingleChildScrollView(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.fitness_center, "Exercise", 0, Colors.green),
            _buildNavItem(Icons.timer, "Time to Calories", 1, Colors.orange),
            _buildNavItem(Icons.recommend, "Suggestions", 2, Colors.blue),
            _buildNavItem(Icons.timer, "Time Setter", 3, Colors.red),
            _buildNavItem(Icons.save, "Templates", 4, Colors.purple),
            _buildNavItem(Icons.calendar_today, "Daily Plan", 5, Colors.teal),
          ],
        ),
      ),
    );
  }

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