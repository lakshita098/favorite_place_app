import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../providers/great_places.dart';

class PlaceDetailScreen extends StatelessWidget {
  static const routeName = '/place-detail';
  const PlaceDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments as String;
    final place = Provider.of<GreatPlaces>(context, listen: false).findById(id);

    return Scaffold(
      appBar: AppBar(title: Text(place.title)),
      body: Column(
        children: [
          SizedBox(
            height: 250,
            width: double.infinity,
            child: Image.file(place.image, fit: BoxFit.cover),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              5,
              (i) => Icon(
                i < place.rating ? Icons.star : Icons.star_border,
                color: Colors.amber,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Lat: ${place.location.latitude}, Lng: ${place.location.longitude}',
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  place.location.latitude,
                  place.location.longitude,
                ),
                zoom: 16,
              ),
              markers: {
                Marker(
                  markerId: const MarkerId('m1'),
                  position: LatLng(
                    place.location.latitude,
                    place.location.longitude,
                  ),
                ),
              },
              onTap: (_) {},
            ),
          ),
        ],
      ),
    );
  }
}
