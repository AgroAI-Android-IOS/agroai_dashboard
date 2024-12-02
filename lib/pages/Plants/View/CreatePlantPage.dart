import 'package:flutter/material.dart';
import 'package:flareline/services/plantService.dart';
import 'package:flareline/pages/Plants/Model/plantModel.dart';
class CreatePlantPage extends StatefulWidget {
  final Plant? plant;  // Add a plant parameter for updates

  CreatePlantPage({this.plant});  // Optional parameter to pass plant for update

  @override
  _CreatePlantPageState createState() => _CreatePlantPageState();
}

class _CreatePlantPageState extends State<CreatePlantPage> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.plant != null) {
      // If plant is provided, populate fields for editing
      _nameController.text = widget.plant!.name;
      _descriptionController.text = widget.plant!.description;
      _imageController.text = widget.plant!.image;
    }
  }

  Future<void> _submitPlant() async {
    final name = _nameController.text;
    final description = _descriptionController.text;
    final image = _imageController.text;

    if (name.isEmpty || description.isEmpty || image.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('All fields are required!')));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final updatedPlant = Plant(
      id: widget.plant?.id ?? '',  // Use existing ID if updating
      name: name,
      description: description,
      image: image,
    );

    bool success = widget.plant == null
        ? await PlantService().addPlant(updatedPlant)  // Add new plant if no plant passed
        : await PlantService().updatePlant(updatedPlant);  // Update existing plant

    setState(() {
      _isLoading = false;
    });

    if (success) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Plant ${widget.plant == null ? 'added' : 'updated'} successfully!')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to ${widget.plant == null ? 'add' : 'update'} plant!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.plant == null ? 'Create New Plant' : 'Edit Plant')),
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
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitPlant,
              child: _isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text(widget.plant == null ? 'Add Plant' : 'Update Plant'),
            ),
          ],
        ),
      ),
    );
  }
}
