import 'dart:io';

class PlaceLocation {
  final double latitude;
  final double longitude;

  const PlaceLocation({required this.latitude, required this.longitude});
}

class Place {
  final String id;
  final String title;
  final PlaceLocation location;
  final File image;
  final int rating; // 1–5

  Place({
    required this.id,
    required this.title,
    required this.location,
    required this.image,
    required this.rating,
  });
}
