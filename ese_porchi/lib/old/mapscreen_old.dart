import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

const LatLng currentLatLng = LatLng(25.1193, 55.3773);

class MapsScreenOld extends StatefulWidget {
  final String selectedLocation;
  const MapsScreenOld({Key? key, required this.selectedLocation})
      : super(key: key);

  @override
  _MapsScreenOldState createState() => _MapsScreenOldState();
}

class _MapsScreenOldState extends State<MapsScreenOld> {
  LatLng? tappedLatLng; // Variable to store the tapped location

  @override
  Widget build(BuildContext context) {
    print(tappedLatLng);
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: CameraPosition(target: currentLatLng, zoom: 14),
        onTap: (LatLng latLng) {
          setState(() {
            tappedLatLng = latLng; // Store the tapped location
          });
        },
        markers: {
          if (tappedLatLng != null)
            Marker(
              markerId: MarkerId('destination'),
              position: tappedLatLng!,
            ),
        },
      ),
    );
  }
}
