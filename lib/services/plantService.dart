import 'dart:convert';
import 'package:flareline/pages/Plants/Model/plantModel.dart';
import 'package:http/http.dart' as http;

class PlantService {
  static const String url = 'http://localhost:3050/api/v1/plant';
    final String token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY3M2NjMDBjNWQxMTcwYzY3MTg2YTVkMiIsIm5hbWUiOiJhaG1lZCIsImVtYWlsIjoiYWhtZWR0ZXN0QGdtYWlsLmNvbSIsImlhdCI6MTczMzEzNTg2NCwiZXhwIjoxNzMzMjIyMjY0fQ.E3VXUKtT0FOFmHuQkYXwhR17Sl_RqsT9tGhQYjPet3c';

  // Fetch all plants
  Future<List<Plant>> fetchPlants() async {
    final String url = 'http://127.0.0.1:3050/api/v1/plant';
    final String token =
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY3M2NjMDBjNWQxMTcwYzY3MTg2YTVkMiIsIm5hbWUiOiJhaG1lZCIsImVtYWlsIjoiYWhtZWR0ZXN0QGdtYWlsLmNvbSIsImlhdCI6MTczMzEzNTg2NCwiZXhwIjoxNzMzMjIyMjY0fQ.E3VXUKtT0FOFmHuQkYXwhR17Sl_RqsT9tGhQYjPet3c';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json', // Optional, depending on your API
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

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
    final String url = 'http://localhost:3050/api/v1/plant';

    final Map<String, dynamic> plantData = {
      'name': plant.name,
      'description': plant.description,
      'image': plant.image,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
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

    try {
      final response = await http.delete(
        Uri.parse('$url/$id'), // Add the plant ID to the URL
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
}
