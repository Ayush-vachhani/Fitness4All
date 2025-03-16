import 'package:flutter/material.dart';

class ReadNotifications extends StatefulWidget {
  @override
  _ReadNotificationsState createState() => _ReadNotificationsState();
}

class _ReadNotificationsState extends State<ReadNotifications> {
  List<String> unreadNotifications = [
    "Request Submitted Successfully.",
    "Your request has moved to 'Upcoming'.",
    "Your request is completed with payment confirmation."
  ];

  List<String> readNotifications = [];

  void markAsRead(int index) {
    setState(() {
      readNotifications.add(unreadNotifications[index]);
      unreadNotifications.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("Notifications"),
        backgroundColor: Colors.purple,
      ),
      body: Column(
        children: [
          // Tabs for Read & Unread Notifications
          DefaultTabController(
            length: 2,
            child: Column(
              children: [
                TabBar(
                  labelColor: Colors.purple,
                  indicatorColor: Colors.purple,
                  tabs: [
                    Tab(text: "Unread (${unreadNotifications.length})"),
                    Tab(text: "Read (${readNotifications.length})"),
                  ],
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.75,
                  child: TabBarView(
                    children: [
                      // Unread Notifications Tab
                      ListView.builder(
                        itemCount: unreadNotifications.length,
                        itemBuilder: (context, index) {
                          return Card(
                            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            child: ListTile(
                              title: Text(unreadNotifications[index]),
                              trailing: IconButton(
                                icon: Icon(Icons.check_circle, color: Colors.green),
                                onPressed: () {
                                  markAsRead(index);
                                },
                              ),
                            ),
                          );
                        },
                      ),

                      // Read Notifications Tab
                      ListView.builder(
                        itemCount: readNotifications.length,
                        itemBuilder: (context, index) {
                          return Card(
                            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            child: ListTile(
                              title: Text(readNotifications[index]),
                              leading: Icon(Icons.check_circle, color: Colors.grey),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}