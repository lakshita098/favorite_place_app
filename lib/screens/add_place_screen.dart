import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

import '../widgets/image_input.dart';
import '../widgets/location_input.dart';
import '../providers/great_places.dart';

class AddPlaceScreen extends StatefulWidget {
  static const routeName = '/add-place';
  const AddPlaceScreen({super.key});

  @override
  State<AddPlaceScreen> createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  final _titleController = TextEditingController();
  File? _pickedImage;
  double? _lat;
  double? _lng;
  int _rating = 3;

  void _selectImage(File image) => _pickedImage = image;
  void _selectPlace(double lat, double lng) {
    _lat = lat;
    _lng = lng;
  }

  void _savePlace() {
    if (_titleController.text.isEmpty ||
        _pickedImage == null ||
        _lat == null ||
        _lng == null)
      return;

    Provider.of<GreatPlaces>(
      context,
      listen: false,
    ).addPlace(_titleController.text, _pickedImage!, _lat!, _lng!, _rating);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add a New Place')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  TextField(
                    decoration: const InputDecoration(labelText: 'Title'),
                    controller: _titleController,
                  ),
                  const SizedBox(height: 10),
                  ImageInput(_selectImage),
                  const SizedBox(height: 10),
                  LocationInput(_selectPlace),
                  const SizedBox(height: 20),
                  const Text('Rate this place:'),
                  RatingBar.builder(
                    initialRating: 3,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: false,
                    itemCount: 5,
                    itemBuilder: (_, __) =>
                        const Icon(Icons.star, color: Colors.amber),
                    onRatingUpdate: (rating) =>
                        setState(() => _rating = rating.toInt()),
                  ),
                ],
              ),
            ),
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('Add Place'),
            onPressed: _savePlace,
          ),
        ],
      ),
    );
  }
}
