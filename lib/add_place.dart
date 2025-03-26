import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:assignment3/user_places.dart';
import 'package:assignment3/place.dart';

const uuid = Uuid();

class AddPlaceScreen extends ConsumerStatefulWidget {
  const AddPlaceScreen({super.key});

  @override
  ConsumerState<AddPlaceScreen> createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends ConsumerState<AddPlaceScreen> {
  final _titleController = TextEditingController();
  File? _selectedImage;
  Location? _pickedLocation;

  Future<void> _pickImage() async {
    final imageFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (imageFile == null) return;

    final appDir = await getApplicationDocumentsDirectory();
    final fileName = imageFile.name;
    final savedImage = await File(imageFile.path).copy('${appDir.path}/$fileName');

    setState(() {
      _selectedImage = savedImage;
    });
  }

  Future<void> _getCurrentLocation() async {
    final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    final placemarks = await geo.placemarkFromCoordinates(position.latitude, position.longitude);
    final address = placemarks.isNotEmpty ? placemarks.first.street ?? 'Unknown' : 'Unknown';

    setState(() {
      _pickedLocation = Location(
        latitude: position.latitude,
        longitude: position.longitude,
        address: address,
      );
    });
  }

  void _savePlace() {
    final enteredTitle = _titleController.text;

    if (enteredTitle.isEmpty || _selectedImage == null || _pickedLocation == null) {
      return;
    }

    final newPlace = Place(
      id: uuid.v4(),
      title: enteredTitle,
      imagePath: _selectedImage!.path,
      location: _pickedLocation!,
    );

    ref.read(userPlacesProvider.notifier).addPlace(newPlace);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Place')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Title'),
              controller: _titleController,
            ),
            const SizedBox(height: 10),
            _selectedImage != null
                ? Image.file(_selectedImage!)
                : const Text('No Image Selected'),
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.camera),
              label: const Text('Pick Image'),
            ),
            const SizedBox(height: 10),
            _pickedLocation != null
                ? Text('Location: ${_pickedLocation!.address}')
                : const Text('No Location Picked'),
            ElevatedButton.icon(
              onPressed: _getCurrentLocation,
              icon: const Icon(Icons.location_on),
              label: const Text('Get Current Location'),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _savePlace,
              icon: const Icon(Icons.add),
              label: const Text('Save Place'),
            ),
          ],
        ),
      ),
    );
  }
}
