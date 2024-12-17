import 'package:flutter/material.dart';
import 'package:flareline/services/plantService.dart';
import 'package:flareline/pages/Plants/Model/plantModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PlantProvider with ChangeNotifier {
  List<Plant> _plants = [];
  bool _isLoading = false;

  List<Plant> get plants => _plants;
  bool get isLoading => _isLoading;

  Future<void> fetchPlants() async {
    _isLoading = true;
    notifyListeners();

    try {
      _plants = await PlantService().fetchPlants();
      await _fetchPlantTypes();
    } catch (e) {
      print('Error fetching plants: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _fetchPlantTypes() async {
    final String apiKey = 'YOUR_GEMINI_AI_API_KEY'; // Replace with your Gemini AI API key

    for (var plant in _plants) {
      if (plant.type.isEmpty) {
        try {
          final response = await http.post(
            Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=$apiKey'),
            headers: {
              'Content-Type': 'application/json',
            },
            body: json.encode({
              "contents": [
                {
                  "parts": [
                    {"text": "Identify the type of the plant named ${plant.name}."}
                  ]
                }
              ]
            }),
          );

          if (response.statusCode == 200) {
            final data = json.decode(response.body);
            final plantType = data['candidates'][0]['content']['parts'][0]['text'];
            plant.type = plantType;
          } else {
            print('Failed to fetch plant type for ${plant.name}');
          }
        } catch (e) {
          print('Error fetching plant type for ${plant.name}: $e');
        }
      }
    }
  }

  Future<bool> addPlant(Plant plant) async {
    _isLoading = true;
    notifyListeners();

    try {
      bool success = await PlantService().addPlant(plant);
      if (success) {
        _plants.add(plant);
        notifyListeners();
      }
      return success;
    } catch (e) {
      print('Error adding plant: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updatePlant(Plant plant) async {
    _isLoading = true;
    notifyListeners();

    try {
      bool success = await PlantService().updatePlant(plant);
      if (success) {
        int index = _plants.indexWhere((p) => p.id == plant.id);
        if (index != -1) {
          _plants[index] = plant;
          notifyListeners();
        }
      }
      return success;
    } catch (e) {
      print('Error updating plant: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}