import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:assignment3/place.dart';

class UserPlacesNotifier extends StateNotifier<List<Place>> {
  UserPlacesNotifier() : super([]) {
    _loadPlaces(); // Загружаем сохранённые места при запуске
  }

  Future<void> _loadPlaces() async {
    final db = await _getDatabase();
    final data = await db.query('places');

    state = data.map((row) => Place(
      id: row['id'] as String,
      title: row['title'] as String,
      imagePath: row['imagePath'] as String,
      location: Location(
        latitude: row['latitude'] as double,
        longitude: row['longitude'] as double,
        address: row['address'] as String,
      ),
    )).toList();
  }

  Future<Database> _getDatabase() async {
    final dir = await getApplicationDocumentsDirectory();
    final dbPath = join(dir.path, 'places.db');

    return openDatabase(dbPath, version: 1, onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE IF NOT EXISTS places (id TEXT PRIMARY KEY, title TEXT, imagePath TEXT, latitude REAL, longitude REAL, address TEXT)',
      );
    });
  }

  Future<void> addPlace(Place place) async {
    final db = await _getDatabase();
    await db.insert('places', {
      'id': place.id,
      'title': place.title,
      'imagePath': place.imagePath,
      'latitude': place.location.latitude,
      'longitude': place.location.longitude,
      'address': place.location.address,
    });

    state = [place, ...state];
  }
}

final userPlacesProvider = StateNotifierProvider<UserPlacesNotifier, List<Place>>(
  (ref) => UserPlacesNotifier(),
);
