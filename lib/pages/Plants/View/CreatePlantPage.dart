import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flareline/pages/Plants/Model/plantModel.dart';
import 'package:flareline_uikit/components/card/common_card.dart';
import 'package:flareline_uikit/components/forms/outborder_text_form_field.dart';
import 'package:flareline/core/theme/global_colors.dart';
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;
import 'package:http/http.dart' as http;
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:provider/provider.dart';
import 'package:flareline/pages/Plants/Providers/plant_provider.dart';

class CreatePlantPage extends StatefulWidget {
  final Plant? plant;

  CreatePlantPage({this.plant});

  @override
  _CreatePlantPageState createState() => _CreatePlantPageState();
}

class _CreatePlantPageState extends State<CreatePlantPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  File? _imageFile;
  Uint8List? _webImage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.plant != null) {
      _nameController.text = widget.plant!.name;
      _descriptionController.text = widget.plant!.description;
      // Load the image from the URL if editing an existing plant
      // _imageFile = File(widget.plant!.image); // This line is just for reference
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (kIsWeb) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _webImage = bytes;
        });
      } else {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    }
  }

  Future<void> _fetchDescription() async {
    final String apiKey =
        'AIzaSyD9STijq89USEXgl0yTGrisYa07YDu-yK0'; // Replace with your Gemini AI API key
    final String plantName = _nameController.text;

    if (plantName.isEmpty) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Error',
        text: 'Please enter the plant name',
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      print('Fetching description for plant: $plantName');
      final response = await http.post(
        Uri.parse(
            'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=$apiKey'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "contents": [
            {
              "parts": [
                {
                  "text":
                      "Describe the plant named $plantName. Include care instructions such as watering frequency, sunlight requirements, and ease of care in a short paragraph."
                }
              ]
            }
          ]
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _descriptionController.text =
              data['candidates'][0]['content']['parts'][0]['text'];
        });
      } else {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Error',
          text: 'Failed to fetch description',
        );
      }
    } catch (e) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Error',
        text: 'Error: $e',
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _submitPlant() async {
    if (_nameController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        (_imageFile == null && _webImage == null && widget.plant == null)) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Error',
        text: 'Please fill all fields and select an image',
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      Plant newPlant = Plant(
        id: widget.plant?.id ??
            '', // Provide a default value or generate a new ID
        name: _nameController.text,
        description: _descriptionController.text,
        image: _webImage != null
            ? base64Encode(_webImage!)
            : _imageFile?.path ?? widget.plant?.image ?? '',
        createdAt: widget.plant?.createdAt ??
            DateTime.now(), // Add the createdAt parameter
        type: widget.plant?.type ?? 'defaultType', // Add the type parameter
      );

      bool success;
      if (widget.plant != null) {
        success = await Provider.of<PlantProvider>(context, listen: false)
            .updatePlant(newPlant); // Update the plant
      } else {
        success = await Provider.of<PlantProvider>(context, listen: false)
            .addPlant(newPlant); // Add a new plant
      }

      if (success) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          title: 'Success',
          text: widget.plant != null
              ? 'Plant updated successfully'
              : 'Plant added successfully',
          onConfirmBtnTap: () {
            Navigator.pop(context, true);
          },
        );
      } else {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Error',
          text: widget.plant != null
              ? 'Failed to update plant'
              : 'Failed to add plant',
        );
      }
    } catch (e) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Error',
        text: 'Error: $e',
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.plant == null ? 'Add Plant' : 'Update Plant'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CommonCard(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OutBorderTextFormField(
                  controller: _nameController,
                  labelText: 'Name',
                  hintText: 'Enter plant name',
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutBorderTextFormField(
                        controller: _descriptionController,
                        labelText: 'Description',
                        hintText: 'Enter plant description',
                        maxLines: 3,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.flash_on, color: GlobalColors.primary),
                      onPressed: _fetchDescription,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: _pickImage,
                  child: kIsWeb
                      ? _webImage == null
                          ? Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(Icons.add_a_photo,
                                  color: Colors.grey[800]),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.memory(
                                _webImage!,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            )
                      : _imageFile == null
                          ? Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(Icons.add_a_photo,
                                  color: Colors.grey[800]),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                _imageFile!,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitPlant,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 12),
                  ),
                  child: _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                          widget.plant == null ? 'Add Plant' : 'Update Plant'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
