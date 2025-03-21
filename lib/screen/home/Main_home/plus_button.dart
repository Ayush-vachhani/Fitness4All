
import 'package:fitness4all/screen/home/Main_home/garph.dart';
import 'package:fitness4all/screen/home/Main_home/home_screen.dart';
import 'package:fitness4all/screen/home/Meals/meals_screen.dart';
import 'package:fitness4all/screen/home/Meals/meals_screen_temp.dart';
import 'package:fitness4all/screen/home/exercises/exercise_screen_temp.dart';
import 'package:fitness4all/screen/home/exercises/exercises_screen.dart';
import 'package:fitness4all/screen/home/notification/notification_screen.dart';
import 'package:flutter/material.dart';



class AddButtonCode extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Please choose an option to add"),
        backgroundColor: Colors.blue[700],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Large Rectangle Tile for Managing Drivers
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomeScreen()));
              },
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.add, size: 50,
                          color: Colors.blue),
                      SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Quick View", style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                          SizedBox(height: 5),
                          Text("Choose what you are going to do TODAY",
                              style: TextStyle(
                                  fontSize: 14, color: Colors.grey[700])),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Grid Tiles for Other Functionalities
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildTile(context, "Add Exercise", Icons.assignment,
                      Colors.orange, () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ExerciseScreen()),
                        );

                      }),
                  _buildTile(
                      context, "Add Meals", Icons.food_bank, Colors.green, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MealsScreen()),
                    );

                  }),
                  _buildTile(context, "Notifications", Icons.notifications,
                      Colors.red, () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => NotificationScreen()),
                        );

                      }),
                  _buildTile(
                    context,
                    "Manage Meal Templates",
                    Icons.local_shipping,
                    Colors.teal,
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MealsScreenTem()),
                      );
                    },
                  ),


                  _buildTile(context, "Manage Exercise Templates",
                      Icons.calendar_today, Colors.blueGrey, () {
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => ExerciseScreenTem()));
                      }),
                  _buildTile(context, "Performance View", Icons.pie_chart,
                      Colors.green, () {
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => ReportsScreen()));
                      }),


                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTile(BuildContext context, String title, IconData icon,
      Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 50, color: color),
              SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center, // Centering the text horizontally
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}