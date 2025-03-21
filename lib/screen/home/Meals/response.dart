// response.dart
import 'package:flutter/material.dart';

class ResponseScreen extends StatelessWidget {
  final Map<String, dynamic> comparison;

  const ResponseScreen({Key? key, required this.comparison}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Comparison Result"),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Unhealthy Food Item:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
            ),
            const SizedBox(height: 10),
            Text("Name: ${comparison['unhealthy']['name']}"),
            Text("Calories: ${comparison['unhealthy']['calories']} kcal"),
            Text("Carbs: ${comparison['unhealthy']['carbs']}g"),
            Text("Protein: ${comparison['unhealthy']['protein']}g"),
            Text("Fats: ${comparison['unhealthy']['fats']}g"),
            Text("Deficiency: ${comparison['unhealthy']['deficiency']}"),
            const SizedBox(height: 20),
            const Text(
              "Healthy Alternative:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            const SizedBox(height: 10),
            Text("Name: ${comparison['healthy']['name']}"),
            Text("Calories: ${comparison['healthy']['calories']} kcal"),
            Text("Carbs: ${comparison['healthy']['carbs']}g"),
            Text("Protein: ${comparison['healthy']['protein']}g"),
            Text("Fats: ${comparison['healthy']['fats']}g"),
            Text("Deficiency: ${comparison['healthy']['deficiency']}"),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Go back to the previous screen
              },
              child: const Text("Go Back"),
            ),
          ],
        ),
      ),
    );
  }
}