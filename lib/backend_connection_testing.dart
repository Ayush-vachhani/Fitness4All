import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final pb = PocketBase('http://10.12.233.180:8090');

  void createWorkout() {
    final body = <String, dynamic>{
      "name": "test"
    };

    pb.collection('DEVICES').create(body: body).then((record) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Workout created: ${record.toString()}')),
      );
    }).catchError((e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Workout Example')),
      body: Center(
        child: ElevatedButton(
          onPressed: createWorkout,
          child: const Text('Create Workout'),
        ),
      ),
    );
  }
}