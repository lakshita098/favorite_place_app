import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationInput extends StatefulWidget {
  final Function(double, double) onSelectPlace;
  const LocationInput(this.onSelectPlace, {super.key});

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  double? _lat;
  double? _lng;

  Future<void> _getCurrentLocation() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }
    if (permission == LocationPermission.deniedForever) return;

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      _lat = position.latitude;
      _lng = position.longitude;
    });
    widget.onSelectPlace(_lat!, _lng!);
  }

  @override
  Widget build(BuildContext context) {
    Widget preview = const Center(child: Text('No Location Chosen'));
    if (_lat != null && _lng != null) {
      preview = GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(_lat!, _lng!),
          zoom: 16,
        ),
        markers: {
          Marker(
            markerId: const MarkerId('m1'),
            position: LatLng(_lat!, _lng!),
          ),
        },
        onTap: (_) {},
      );
    }

    return Column(
      children: [
        Container(
          height: 150,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
          ),
          child: preview,
        ),
        const SizedBox(height: 10),
        TextButton.icon(
          icon: const Icon(Icons.location_on),
          label: const Text('Current Location'),
          onPressed: _getCurrentLocation,
        ),
      ],
    );
  }
}
