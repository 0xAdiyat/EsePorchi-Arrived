import 'package:ese_porchi/main.dart';
import 'package:ese_porchi/maps_screen.dart';
import 'package:ese_porchi/search_location_screen.dart';
import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.deepOrangeAccent,
        ),
        body: Center(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.deepOrangeAccent,
              borderRadius: BorderRadius.circular(5),
            ),
            height: 80,
            width: 200,
            child: ElevatedButton(
              // onPressed: triggerNotification,
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => SearchLocationScreen()));
              },
              child: Text("Click"),
            ),
          ),
        ),
      ),
    );
  }

  void triggerNotification() {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: 10,
          channelKey: "basic_channel",
          title: "Simple_Notification",
          body: "This is a simple notification"),
    );
  }
}
