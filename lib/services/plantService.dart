import 'dart:convert';

import 'package:flareline/core/constant.dart';
import 'package:flareline/pages/Plants/Model/plantModel.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PlantService {
  static const String baseUrl = '${Constant.baseUrl}/plant';

  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    print(prefs.getString("token"));
    return prefs.getString('token') ?? '';
  }

  // Fetch all plants
  Future<List<Plant>> fetchPlants() async {
    final String token = await _getToken();

    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json', // Optional, depending on your API
        },
      );

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        return jsonResponse.map((plant) => Plant.fromJson(plant)).toList();
      } else {
        throw Exception('Failed to load plants');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load plants');
    }
  }

  Future<bool> addPlant(Plant plant) async {
    print("*****************");
    final String token = await _getToken();
    print(token);
    final Map<String, dynamic> plantData = {
      'name': plant.name,
      'description': plant.description,
      'image': plant.image,
    };

    print(token);

    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(plantData),
      );

      if (response.statusCode == 201) {
        // Successfully added the plant
        return true;
      } else {
        // Handle other status codes or errors
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false; // Return false if an error occurs
    }
  }

  // Delete a plant by ID
  Future<bool> deletePlant(String id) async {
    final String token = await _getToken();

    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/$id'), // Add the plant ID to the URL
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        // Successfully deleted the plant
        return true;
      } else {
        throw Exception('Failed to delete plant');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to delete plant');
    }
  }

  Future<bool> updatePlant(Plant plant) async {
    final String url =
        '$baseUrl/${plant.id}'; // URL to update the specific plant
    final String token = await _getToken();

    // Prepare the updated plant data (taking the values from the Plant object)
    final Map<String, dynamic> updatedPlantData = {
      'name': plant.name,
      'description': plant.description,
      'image': plant.image,
    };

    try {
      final response = await http.patch(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json
            .encode(updatedPlantData), // Send the updated plant data as JSON
      );

      if (response.statusCode == 200) {
        // Successfully updated the plant
        print('Plant updated successfully!');
        return true;
      } else {
        // Handle failure (e.g., validation error, server error)
        print('Failed to update plant: ${response.body}');
        return false;
      }
    } catch (e) {
      // Handle any errors that occur (e.g., network issue)
      print('Error updating plant: $e');
      return false;
    }
  }
}
