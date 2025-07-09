import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/great_places.dart';
import 'add_place_screen.dart';
import 'place_detail_screen.dart';

class PlaceListScreen extends StatefulWidget {
  const PlaceListScreen({super.key});

  @override
  State<PlaceListScreen> createState() => _PlaceListScreenState();
}

class _PlaceListScreenState extends State<PlaceListScreen> {
  String _search = '';

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GreatPlaces>(context);
    final places = provider.items
        .where((p) => p.title.toLowerCase().contains(_search.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Places'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () =>
                Navigator.of(context).pushNamed(AddPlaceScreen.routeName),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search places…',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (val) => setState(() => _search = val),
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: provider.fetchAndSetPlaces(),
              builder: (_, snap) =>
                  snap.connectionState == ConnectionState.waiting
                  ? const Center(child: CircularProgressIndicator())
                  : places.isEmpty
                  ? const Center(child: Text('No places yet'))
                  : ListView.builder(
                      itemCount: places.length,
                      itemBuilder: (_, i) => ListTile(
                        leading: CircleAvatar(
                          backgroundImage: FileImage(places[i].image),
                        ),
                        title: Row(
                          children: [
                            Text(places[i].title),
                            const SizedBox(width: 6),
                            Icon(Icons.star, size: 18, color: Colors.amber),
                            Text('${places[i].rating}'),
                          ],
                        ),
                        onTap: () => Navigator.of(context).pushNamed(
                          PlaceDetailScreen.routeName,
                          arguments: places[i].id,
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
