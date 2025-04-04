import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

void main() {
  runApp(const MyApp());
}
// goals landing page
//nav bar
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fitness App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomeLandingPage(),
    );
  }
}

class HomeLandingPage extends StatelessWidget {
  const HomeLandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fitness App'),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Welcome Back!",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Let's achieve your fitness goals today!",
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                buildFeatureButton(
                  context,
                  "Set Daily, Weekly, Monthly Goals",
                  Icons.flag,
                  Colors.orange,
                  const GoalSettingPage(),
                ),
                buildFeatureButton(
                  context,
                  "Specify Weight, Sleep, Calorie Goals",
                  Icons.fitness_center,
                  Colors.red,
                  const SpecificGoalSettingPage(),
                ),
                buildFeatureButton(
                  context,
                  "Update Goals",
                  Icons.edit,
                  Colors.green,
                  const UpdateGoalsPage(),
                ),
                buildFeatureButton(
                  context,
                  "Receive Reminders",
                  Icons.notifications,
                  Colors.purple,
                  const RemindersPage(),
                ),
                buildFeatureButton(
                  context,
                  "View Goal Progress Summary",
                  Icons.bar_chart,
                  Colors.teal,
                  const ProgressSummaryPage(),
                ),
                buildFeatureButton(
                  context,
                  "Set Time-Based Challenges",
                  Icons.timer,
                  Colors.blue,
                  const TimeBasedChallengesPage(),
                ),
                buildFeatureButton(
                  context,
                  "Share Goals with Friends",
                  Icons.share,
                  Colors.pink,
                  const ShareGoalsPage(),
                ),
                buildFeatureButton(
                  context,
                  "Receive Tips and Strategies",
                  Icons.lightbulb,
                  Colors.amber,
                  const TipsStrategiesPage(),
                ),
                buildFeatureButton(
                  context,
                  "Sync with Wearable Devices",
                  Icons.watch,
                  Colors.indigo,
                  const SyncWearablePage(),
                ),
                buildFeatureButton(
                  context,
                  "Get Milestone Notifications",
                  Icons.celebration,
                  Colors.cyan,
                  const MilestoneNotificationsPage(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFeatureButton(BuildContext context, String title, IconData icon, Color color, Widget page) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24),
            const SizedBox(width: 10),
            Text(title, style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}

// Feature Pages
class GoalSettingPage extends StatefulWidget {
  const GoalSettingPage({super.key});

  @override
  _GoalSettingPageState createState() => _GoalSettingPageState();
}

class _GoalSettingPageState extends State<GoalSettingPage> {
  String dailyGoal = "Not set";
  String weeklyGoal = "Not set";

  void _setGoal(String type) {
    TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Enter $type Goal"),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: "Enter goal"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  if (type == "Daily") {
                    dailyGoal = controller.text;
                  } else if (type == "Weekly") {
                    weeklyGoal = controller.text;
                  }
                });
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Set Daily, Weekly, Monthly Goals")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ListTile(
              title: const Text("Daily Goal"),
              subtitle: Text(dailyGoal),
              trailing: IconButton(
                icon: const Icon(Icons.edit, color: Colors.orange),
                onPressed: () => _setGoal("Daily"),
              ),
            ),
            ListTile(
              title: const Text("Weekly Goal"),
              subtitle: Text(weeklyGoal),
              trailing: IconButton(
                icon: const Icon(Icons.edit, color: Colors.green),
                onPressed: () => _setGoal("Weekly"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SpecificGoalSettingPage extends StatefulWidget {
  const SpecificGoalSettingPage({super.key});

  @override
  _SpecificGoalSettingPageState createState() => _SpecificGoalSettingPageState();
}

class _SpecificGoalSettingPageState extends State<SpecificGoalSettingPage> {
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _calorieController = TextEditingController();
  final TextEditingController _sleepController = TextEditingController();

  static String? savedWeight;
  static String? savedCalories;
  static String? savedSleep;

  void saveGoals() {
    setState(() {
      savedWeight = _weightController.text;
      savedCalories = _calorieController.text;
      savedSleep = _sleepController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Specify Weight, Sleep, Calorie Goals")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Enter Your Goals", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            TextField(
              controller: _weightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Weight (kg)", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _calorieController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Daily Calorie Intake", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _sleepController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Sleep Hours", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: saveGoals,
              child: const Text("Save Goals"),
            ),
            const SizedBox(height: 20),
            if (savedWeight != null || savedCalories != null || savedSleep != null) ...[
              const Text("Saved Goals:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              if (savedWeight != null) Text("Weight: $savedWeight kg"),
              if (savedCalories != null) Text("Calories: $savedCalories kcal"),
              if (savedSleep != null) Text("Sleep: $savedSleep hours"),
            ],
          ],
        ),
      ),
    );
  }
}

class UpdateGoalsPage extends StatefulWidget {
  const UpdateGoalsPage({super.key});

  @override
  _UpdateGoalsPageState createState() => _UpdateGoalsPageState();
}

class _UpdateGoalsPageState extends State<UpdateGoalsPage> {
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _calorieController = TextEditingController();
  final TextEditingController _sleepController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _weightController.text = _SpecificGoalSettingPageState.savedWeight ?? "";
    _calorieController.text = _SpecificGoalSettingPageState.savedCalories ?? "";
    _sleepController.text = _SpecificGoalSettingPageState.savedSleep ?? "";
  }

  void updateGoals() {
    setState(() {
      _SpecificGoalSettingPageState.savedWeight = _weightController.text;
      _SpecificGoalSettingPageState.savedCalories = _calorieController.text;
      _SpecificGoalSettingPageState.savedSleep = _sleepController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Update Goals")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Update Your Goals", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            TextField(
              controller: _weightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Weight (kg)", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _calorieController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Daily Calorie Intake", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _sleepController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Sleep Hours", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: updateGoals,
              child: const Text("Update Goals"),
            ),
          ],
        ),
      ),
    );
  }
}

class RemindersPage extends StatelessWidget {
  const RemindersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Receive Reminders")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            buildGoalOption(context, "Set Daily Reminder", Icons.today, Colors.orange),
            buildGoalOption(context, "Set Weekly Reminder", Icons.calendar_view_week, Colors.green),
            buildGoalOption(context, "Set Monthly Reminder", Icons.calendar_today, Colors.blue),
          ],
        ),
      ),
    );
  }

  Widget buildGoalOption(BuildContext context, String title, IconData icon, Color color) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.only(bottom: 15),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title, style: const TextStyle(fontSize: 18)),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("$title clicked!")),
          );
        },
      ),
    );
  }
}

class ProgressSummaryPage extends StatelessWidget {
  const ProgressSummaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("View Goal Progress Summary")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            buildGoalOption(context, "View Daily Progress", Icons.today, Colors.orange),
            buildGoalOption(context, "View Weekly Progress", Icons.calendar_view_week, Colors.green),
            buildGoalOption(context, "View Monthly Progress", Icons.calendar_today, Colors.blue),
          ],
        ),
      ),
    );
  }

  Widget buildGoalOption(BuildContext context, String title, IconData icon, Color color) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.only(bottom: 15),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title, style: const TextStyle(fontSize: 18)),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("$title clicked!")),
          );
        },
      ),
    );
  }
}

class TimeBasedChallengesPage extends StatelessWidget {
  const TimeBasedChallengesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Set Time-Based Challenges")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            buildGoalOption(context, "Set 7-Day Challenge", Icons.timer, Colors.orange, const SevenDayChallengePage()),
            buildGoalOption(context, "Set 30-Day Challenge", Icons.timer_10, Colors.green, const ThirtyDayChallengePage()),
            buildGoalOption(context, "Set 90-Day Challenge", Icons.timer_3, Colors.blue, const NinetyDayChallengePage()),
          ],
        ),
      ),
    );
  }

  Widget buildGoalOption(BuildContext context, String title, IconData icon, Color color, [Widget? page]) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.only(bottom: 15),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title, style: const TextStyle(fontSize: 18)),
        onTap: () {
          if (page != null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => page),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("$title clicked!")),
            );
          }
        },
      ),
    );
  }
}

class SevenDayChallengePage extends StatefulWidget {
  const SevenDayChallengePage({super.key});

  @override
  _SevenDayChallengePageState createState() => _SevenDayChallengePageState();
}

class _SevenDayChallengePageState extends State<SevenDayChallengePage> {
  final List<bool> _dayCompletionStatus = List.generate(7, (index) => false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("7-Day Challenge")),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: 7,
        itemBuilder: (context, index) {
          return Card(
            elevation: 3,
            margin: const EdgeInsets.only(bottom: 10),
            child: CheckboxListTile(
              title: Text("Day ${index + 1}"),
              value: _dayCompletionStatus[index],
              onChanged: (bool? value) {
                setState(() {
                  _dayCompletionStatus[index] = value ?? false;
                });
              },
              secondary: const Icon(Icons.calendar_today),
            ),
          );
        },
      ),
    );
  }
}

class ThirtyDayChallengePage extends StatefulWidget {
  const ThirtyDayChallengePage({super.key});

  @override
  _ThirtyDayChallengePageState createState() => _ThirtyDayChallengePageState();
}

class _ThirtyDayChallengePageState extends State<ThirtyDayChallengePage> {
  final List<bool> _dayCompletionStatus = List.generate(30, (index) => false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("30-Day Challenge")),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: 30,
        itemBuilder: (context, index) {
          return Card(
            elevation: 3,
            margin: const EdgeInsets.only(bottom: 10),
            child: CheckboxListTile(
              title: Text("Day ${index + 1}"),
              value: _dayCompletionStatus[index],
              onChanged: (bool? value) {
                setState(() {
                  _dayCompletionStatus[index] = value ?? false;
                });
              },
              secondary: const Icon(Icons.calendar_today),
            ),
          );
        },
      ),
    );
  }
}

class NinetyDayChallengePage extends StatefulWidget {
  const NinetyDayChallengePage({super.key});

  @override
  _NinetyDayChallengePageState createState() => _NinetyDayChallengePageState();
}

class _NinetyDayChallengePageState extends State<NinetyDayChallengePage> {
  final List<bool> _dayCompletionStatus = List.generate(90, (index) => false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("90-Day Challenge")),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: 90,
        itemBuilder: (context, index) {
          return Card(
            elevation: 3,
            margin: const EdgeInsets.only(bottom: 10),
            child: CheckboxListTile(
              title: Text("Day ${index + 1}"),
              value: _dayCompletionStatus[index],
              onChanged: (bool? value) {
                setState(() {
                  _dayCompletionStatus[index] = value ?? false;
                });
              },
              secondary: const Icon(Icons.calendar_today),
            ),
          );
        },
      ),
    );
  }
}


class ShareGoalsPage extends StatelessWidget {
  const ShareGoalsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Share Goals with Friends")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            buildGoalOption(context, "Share Daily Goals", Icons.today, Colors.orange),
            buildGoalOption(context, "Share Weekly Goals", Icons.calendar_view_week, Colors.green),
            buildGoalOption(context, "Share Monthly Goals", Icons.calendar_today, Colors.blue),
          ],
        ),
      ),
    );
  }

  Widget buildGoalOption(BuildContext context, String title, IconData icon, Color color) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.only(bottom: 15),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title, style: const TextStyle(fontSize: 18)),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("$title clicked!")),
          );
        },
      ),
    );
  }
}

class TipsStrategiesPage extends StatelessWidget {
  const TipsStrategiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Receive Tips and Strategies")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            buildGoalOption(
                context,
                "Tips for Weight Loss",
                Icons.monitor_weight,
                Colors.red,
                [
                  "1. Eat more protein to feel full longer",
                  "2. Reduce sugar and refined carbs intake",
                  "3. Drink plenty of water before meals",
                  "4. Get enough sleep (7-9 hours)",
                  "5. Incorporate strength training 2-3 times per week"
                ]
            ),
            buildGoalOption(
                context,
                "Tips for Better Sleep",
                Icons.bedtime,
                Colors.blue,
                [
                  "1. Maintain a consistent sleep schedule",
                  "2. Create a relaxing bedtime routine",
                  "3. Avoid caffeine and screens before bed",
                  "4. Keep your bedroom cool and dark",
                  "5. Exercise regularly but not too close to bedtime"
                ]
            ),
            buildGoalOption(
                context,
                "Tips for Calorie Control",
                Icons.local_fire_department,
                Colors.green,
                [
                  "1. Use smaller plates to control portions",
                  "2. Eat slowly and mindfully",
                  "3. Track your food intake with an app",
                  "4. Choose whole foods over processed ones",
                  "5. Plan meals ahead to avoid impulsive eating"
                ]
            ),
          ],
        ),
      ),
    );
  }

  Widget buildGoalOption(BuildContext context, String title, IconData icon, Color color, List<String> tips) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.only(bottom: 15),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title, style: const TextStyle(fontSize: 18)),
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(title),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: tips.map((tip) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(tip),
                    )).toList(),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Close"),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
class SyncWearablePage extends StatelessWidget {
  const SyncWearablePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sync with Wearable Devices")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            buildDeviceOption(context, "Sync with Smartwatch", Icons.watch, Colors.indigo),
            buildDeviceOption(context, "Sync with Fitness Tracker", Icons.fitness_center, Colors.purple),
          ],
        ),
      ),
    );
  }

  Widget buildDeviceOption(BuildContext context, String title, IconData icon, Color color) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.only(bottom: 15),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title, style: const TextStyle(fontSize: 18)),
        onTap: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Connect $title", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    ListTile(
                      leading: const Icon(Icons.bluetooth, color: Colors.blue),
                      title: const Text("Connect via Bluetooth"),
                      onTap: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Connecting $title via Bluetooth")),
                        );
                        // Add actual Bluetooth connection logic here
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.wifi, color: Colors.green),
                      title: const Text("Connect via Wi-Fi"),
                      onTap: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Connecting $title via Wi-Fi")),
                        );
                        // Add actual Wi-Fi connection logic here
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class MilestoneNotificationsPage extends StatelessWidget {
  const MilestoneNotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Get Milestone Notifications")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            buildGoalOption(context, "Daily Milestone", Icons.today, Colors.orange),
            buildGoalOption(context, "Weekly Milestone", Icons.calendar_view_week, Colors.green),
            buildGoalOption(context, "Monthly Milestone", Icons.calendar_today, Colors.blue),
          ],
        ),
      ),
    );
  }

  Widget buildGoalOption(BuildContext context, String title, IconData icon, Color color) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.only(bottom: 15),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title, style: const TextStyle(fontSize: 18)),
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text("$title Notification"),
              content: Text("We will notify you once you achieve this $title!"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("OK"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("$title notifications enabled!")),
                    );
                  },
                  child: const Text("Enable Notifications"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}