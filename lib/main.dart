import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/great_places.dart';
import 'screens/add_place_screen.dart';
import 'screens/place_list_screen.dart';
import 'screens/place_detail_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GreatPlaces(),
      child: MaterialApp(
        title: 'Favorite Places',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
          useMaterial3: true,
        ),
        home: const PlaceListScreen(),
        routes: {
          AddPlaceScreen.routeName: (_) => const AddPlaceScreen(),
          PlaceDetailScreen.routeName: (_) => const PlaceDetailScreen(),
        },
      ),
    );
  }
}
