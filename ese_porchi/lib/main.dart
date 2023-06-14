import 'dart:developer' as developer;

import 'dart:isolate';

import 'dart:ui';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:ese_porchi/screens/main_screen.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

const String countKey = 'count';

const String isolateName = 'isolate';

ReceivePort port = ReceivePort();

SharedPreferences? prefs;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AndroidAlarmManager.initialize();
  final int helloAlarmID = 7;
  await AndroidAlarmManager.periodic(
      const Duration(seconds: 3), helloAlarmID, printHello);
  GeocodingPlatform.instance;
  AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
            channelGroupKey: 'basic_channel_group',
            channelKey: 'basic_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            defaultColor: Color(0xFF9D50DD),
            ledColor: Colors.white)
      ],
      channelGroups: [
        NotificationChannelGroup(
            channelGroupKey: 'basic_channel_group',
            channelGroupName: 'Basic group')
      ],
      debug: true);

  IsolateNameServer.registerPortWithName(
    port.sendPort,
    isolateName,
  );
  prefs = await SharedPreferences.getInstance();
  if (!prefs!.containsKey(countKey)) {
    await prefs!.setInt(countKey, 0);
  }

  runApp(const EsePorchiMain());
}

class EsePorchiMain extends StatefulWidget {
  const EsePorchiMain({Key? key}) : super(key: key);

  @override
  State<EsePorchiMain> createState() => _EsePorchiMainState();
}

class _EsePorchiMainState extends State<EsePorchiMain> {
  @override
  void initState() {
    super.initState();
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EsePorchi-Arrived',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.greenAccent,
      ),
      home: const MainScreen(),
    );
  }
}

@pragma('vm:entry-point')
void printHello() {
  final DateTime now = DateTime.now();
  final int isolateId = Isolate.current.hashCode;
  print("[$now] Hello, world! isolate=${isolateId} function='$printHello'");
}
