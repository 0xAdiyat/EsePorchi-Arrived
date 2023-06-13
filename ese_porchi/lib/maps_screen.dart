import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsScreen extends StatefulWidget {
  final String selectedLocation;

  const MapsScreen({Key? key, required this.selectedLocation})
      : super(key: key);

  @override
  _MapsScreenState createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Location>>(
        future: searchLocation(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While waiting for the result, you can show a loading indicator
            return Center(
                child: CupertinoActivityIndicator(
              color: Colors.greenAccent,
            ));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error occurred: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            // If the searchLocation() operation completed successfully and returned a non-empty list of locations
            final selectedLatLng = LatLng(
                snapshot.data!.first.latitude, snapshot.data!.first.longitude);
            return GoogleMap(
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
            );
          } else {
            // If no location was found or the searchLocation() operation returned an empty list of locations
            return Center(child: Text('No location found'));
          }
        },
      ),
    );
  }
}
