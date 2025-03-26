import 'dart:io';
import 'package:assignment3/place_detail.dart';
import 'package:flutter/material.dart';
import 'package:assignment3/place.dart';

class PlacesList extends StatelessWidget {
  const PlacesList({super.key, required this.places});

  final List<Place> places;

  @override
  Widget build(BuildContext context) {
    if (places.isEmpty) {
      return Center(
        child: Text(
          'No places added yet',
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
              ),
        ),
      );
    }

    return ListView.builder(
      itemCount: places.length,
      itemBuilder: (ctx, index) => Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: ListTile(
          leading: places[index].imagePath.isNotEmpty && File(places[index].imagePath).existsSync()
              ? Image.file(File(places[index].imagePath), width: 50, height: 50, fit: BoxFit.cover)
              : const Icon(Icons.image_not_supported, size: 50),

          title: Text(
            places[index].title,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
          ),

          subtitle: Text(places[index].location.address), // ✅ Добавил отображение адреса

          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => PlaceDetailScreen(place: places[index]),
              ),
            );
          },
        ),
      ),
    );
  }
}
