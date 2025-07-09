import 'dart:io';
import 'package:flutter/material.dart';

import '../helpers/db_helper.dart';
import '../models/place.dart';

class GreatPlaces with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items => [..._items];

  Place findById(String id) => _items.firstWhere((element) => element.id == id);

  Future<void> addPlace(
    String title,
    File image,
    double lat,
    double lng,
    int rating,
  ) async {
    final newPlace = Place(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      location: PlaceLocation(latitude: lat, longitude: lng),
      image: image,
      rating: rating,
    );
    _items.add(newPlace);
    notifyListeners();

    await DBHelper.insert('user_places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
      'loc_lat': newPlace.location.latitude,
      'loc_lng': newPlace.location.longitude,
      'rating': newPlace.rating,
    });
  }

  Future<void> fetchAndSetPlaces() async {
    final dataList = await DBHelper.getData('user_places');
    _items = dataList
        .map(
          (item) => Place(
            id: item['id'],
            title: item['title'],
            image: File(item['image']),
            location: PlaceLocation(
              latitude: item['loc_lat'],
              longitude: item['loc_lng'],
            ),
            rating: item['rating'] ?? 3,
          ),
        )
        .toList();
    notifyListeners();
  }
}
