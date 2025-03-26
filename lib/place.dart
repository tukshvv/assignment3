import 'dart:io';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

class Place {
  Place({
    required this.id,
    required this.title,
    required this.imagePath,
    required this.location,
  });

  final String id;
  final String title;
  final String imagePath;
  final Location location;
}

class Location {
  final double latitude;
  final double longitude;
  final String address;

  Location({
    required this.latitude,
    required this.longitude,
    required this.address,
  });
}
