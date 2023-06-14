import 'dart:convert';

import 'package:ese_porchi/screens/main_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MapsScreen extends StatefulWidget {
  final String selectedLocation;

  const MapsScreen({Key? key, required this.selectedLocation})
      : super(key: key);

  @override
  _MapsScreenState createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  int alarmCount = 1;
  String destination = "";

  Future<List<Location>> searchLocation() async {
    try {
      List<Location> locations =
          await locationFromAddress(widget.selectedLocation);

      return locations;
    } catch (e) {
      debugPrint('Error occurred while searching location: $e');
      return [];
    }
  }

  Future<void> storeDestinationAndNavigateToMainScreen(
      LatLng destination) async {
    SharedPreferences sp = await SharedPreferences.getInstance();

    List<List<String>> destinations = [];
    int alarmCount = sp.getInt("alarm_count") ?? 0;

    for (int i = 1; i <= alarmCount; i++) {
      String destinationJson = sp.getString("destinations_$i") ?? "[]";
      List<String> destination = (jsonDecode(destinationJson) as List<dynamic>)
          .map((dynamic item) => item.toString())
          .toList();
      destinations.add(destination);
    }

    List<String> newDestination = [
      destination.latitude.toString(),
      destination.longitude.toString(),
    ];

    destinations.add(newDestination);

    sp.setInt("alarm_count", alarmCount + 1);

    for (int i = 0; i < destinations.length; i++) {
      List<String> destination = destinations[i];
      sp.setString("destinations_${i + 1}", jsonEncode(destination));
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => MainScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Location>>(
        future: searchLocation(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CupertinoActivityIndicator(
                color: Colors.greenAccent,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error occurred: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final selectedLatLng = LatLng(
                snapshot.data!.first.latitude, snapshot.data!.first.longitude);
            return Column(
              children: [
                Expanded(
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: selectedLatLng,
                      zoom: 14,
                    ),
                    markers: {
                      Marker(
                        markerId: MarkerId('destination'),
                        position: selectedLatLng,
                      ),
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () =>
                      storeDestinationAndNavigateToMainScreen(selectedLatLng),
                  child: Text('Save Destination and Go to MainScreen'),
                ),
              ],
            );
          } else {
            return Center(child: Text('No location found'));
          }
        },
      ),
    );
  }
}