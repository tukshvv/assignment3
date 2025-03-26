import 'dart:io';
import 'package:flutter/material.dart';
import 'package:assignment3/place.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaceDetailScreen extends StatelessWidget {
  const PlaceDetailScreen({super.key, required this.place});

  final Place place;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(place.title)),
      body: Column(
        children: [
          if (File(place.imagePath).existsSync()) // ✅ Проверка, существует ли фото
            Image.file(File(place.imagePath), width: double.infinity, height: 250, fit: BoxFit.cover)
          else
            const Text('❌ Ошибка загрузки фото'),

          const SizedBox(height: 10),
          Text(
            'Адрес: ${place.location.address}',
            style: Theme.of(context).textTheme.titleMedium,
          ),

          const SizedBox(height: 10),
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(place.location.latitude, place.location.longitude),
                zoom: 15,
              ),
              markers: {
                Marker(
                  markerId: MarkerId(place.id),
                  position: LatLng(place.location.latitude, place.location.longitude),
                ),
              },
            ),
          ),
        ],
      ),
    );
  }
}
