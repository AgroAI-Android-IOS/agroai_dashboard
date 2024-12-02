import 'package:flutter/material.dart';
import 'package:flareline/services/plantService.dart';
import 'package:flareline/pages/Plants/Model/plantModel.dart';

class CreatePlantPage extends StatefulWidget {
  @override
  _CreatePlantPageState createState() => _CreatePlantPageState();
}

class _CreatePlantPageState extends State<CreatePlantPage> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageController = TextEditingController();

  bool _isLoading = false;

  // Submit the new plant to the backend
  Future<void> _submitPlant() async {
    final name = _nameController.text;
    final description = _descriptionController.text;
    final image = _imageController.text;

    // Validate that all fields are filled
    if (name.isEmpty || description.isEmpty || image.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('All fields are required!')));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final newPlant = Plant(id: '', name: name, description: description, image: image);

    try {
      // Call the addPlant method to send the new plant data to the backend
      bool success = await PlantService().addPlant(newPlant);

      if (success) {
        // On success, navigate back and show success message
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Plant added successfully!')));
      } else {
        // If unsuccessful, show failure message
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to add plant!')));
      }
    } catch (e) {
      // Handle any errors during the request
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('An error occurred: $e')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create New Plant')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Plant Name'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
            TextField(
              controller: _imageController,
              decoration: InputDecoration(labelText: 'Image URL'),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _submitPlant,
                    child: Text('Add Plant'),
                  ),
          ],
        ),
      ),
    );
  }
}
