import 'dart:async';
import 'dart:convert';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:ese_porchi/utilities/constants.dart';
import 'package:ese_porchi/screens/search_location_screen.dart';
import 'package:ese_porchi/utilities/utilities.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geodesy/geodesy.dart';
import 'package:http/http.dart' as http;

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<List<String>> loadDestination = [];
  int loadAlarmCount = 0;
  double currentLatitude = 0.0, currentLongitude = 0.0;

  @override
  void initState() {
    super.initState();
    loadData();
    Timer.periodic(Duration(seconds: 10), (Timer t) {
      loadData().then((value) async {
        setState(() {});
        getCurrentLocation();
      });
    });
  }

  void getCurrentLocation() async {
    var position = await _determinePosition();
    setState(() {
      currentLatitude = position.latitude;
      currentLongitude = position.longitude;
    });

    for (var destination in loadDestination) {
      double latitude = double.parse(destination[0]);
      double longitude = double.parse(destination[1]);
      triggerNotification(latitude, longitude);
    }
  }

  void triggerNotification(
      double destinationLatitude, double destinationLongitude) async {
    num distance = calculateDistance(
      currentLatitude,
      currentLongitude,
      destinationLatitude,
      destinationLongitude,
    );
    print("Distance is: $distance  Triggered");
    if (distance <= 20) {
      print("Destinations" + distance.toString());
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          displayOnBackground: true,
          displayOnForeground: true,
          id: createUniqueID(),
          channelKey: "basic_channel",
          title: "${Emojis.building_house} Hey! EsePorchi",
          body: "We have reached your destination.",
        ),
      );
    }
  }

  num calculateDistance(double lat1, double lng1, double lat2, double lng2) {
    final Geodesy geodesy = Geodesy();

    LatLng p1 = LatLng(lat1, lng1);
    LatLng p2 = LatLng(lat2, lng2);
    num distance = geodesy.distanceBetweenTwoGeoPoints(p1, p2);
    return distance;
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<void> loadData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    loadAlarmCount = sp.getInt("alarm_count") ?? 0;
    loadDestination.clear();

    for (int i = 1; i <= loadAlarmCount; i++) {
      String destinationJson = sp.getString("destinations_$i") ?? "[]";
      List<dynamic> destinationList =
          jsonDecode(destinationJson) as List<dynamic>;
      List<String> destination =
          destinationList.map((dynamic item) => item.toString()).toList();
      loadDestination.add(destination);
    }

    print("Stored data $loadAlarmCount and $loadDestination");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        title: Text("EsePorchi - Arrived"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          loadDestination.isEmpty
              ? Center(
                  child: Card(
                    elevation: 0.5,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                const SearchLocationScreen()));
                      },
                      child: SizedBox(
                        height: 200,
                        width: 190,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add,
                              size: 50,
                              color: Colors.greenAccent,
                            ),
                            Text(
                              "Add destination",
                              style: TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: loadDestination.length,
                  padding: EdgeInsets.all(16),
                  itemBuilder: (context, index) {
                    print(loadDestination);
                    final latitude = double.parse(loadDestination[index][0]);
                    final longitude = double.parse(loadDestination[index][1]);

                    return FutureBuilder<String>(
                      future: reverseGeocode(latitude, longitude),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final location = snapshot.data!;

                          return Padding(
                            padding: EdgeInsets.only(bottom: 16),
                            child: Card(
                              elevation: 1,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: ListTile(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 16),
                                leading: Icon(Icons.alarm,
                                    size: 32, color: Colors.green),
                                title: Text(
                                  "Alarm ${index + 1}",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  "Location: $location",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                trailing: Icon(Icons.arrow_forward,
                                    size: 28, color: Colors.green),
                                onTap: () async {
                                  print("0xAdiyat");
                                },
                              ),
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: 16),
                            child: Card(
                              elevation: 1,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: ListTile(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 16),
                                leading: Icon(Icons.alarm,
                                    size: 32, color: Colors.green),
                                title: Text(
                                  "Alarm ${index + 1}",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  "Location: Unknown",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                trailing: Icon(Icons.arrow_forward,
                                    size: 28, color: Colors.green),
                                onTap: () {
                                  // Handle alarm selection
                                },
                              ),
                            ),
                          );
                        } else {
                          return Padding(
                            padding: EdgeInsets.only(bottom: 16),
                            child: Card(
                              elevation: 1,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: ListTile(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 16),
                                leading: Icon(Icons.alarm,
                                    size: 32, color: Colors.green),
                                title: Text(
                                  "Alarm ${index + 1}",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  "Loading location...",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                trailing: Icon(Icons.arrow_forward,
                                    size: 28, color: Colors.green),
                                onTap: () {
                                  // Handle alarm selection
                                },
                              ),
                            ),
                          );
                        }
                      },
                    );
                  },
                ),
        ],
      ),
      floatingActionButton: loadAlarmCount != 0
          ? FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => SearchLocationScreen()));
              },
              child: Icon(Icons.add),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            )
          : null,
    );
  }

  Future<String> reverseGeocode(double latitude, double longitude) async {
    const API_KEY = apiKey;
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$API_KEY';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final results = json['results'] as List<dynamic>;
      if (results.isNotEmpty) {
        final firstResult = results.first;
        final formattedAddress = firstResult['formatted_address'];
        return formattedAddress;
      }
    }

    return 'Unknown location';
  }
}
