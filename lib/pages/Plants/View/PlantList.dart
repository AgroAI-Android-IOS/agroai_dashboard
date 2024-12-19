import 'dart:convert';
import 'dart:io';

import 'package:flareline/pages/Plants/Model/plantModel.dart';
import 'package:flareline/pages/Plants/View/CreatePlantPage.dart';
import 'package:flareline/pages/Plants/View/PlantDetailPage.dart';
import 'package:flareline/pages/layout.dart';
import 'package:flareline/services/plantService.dart';
import 'package:flareline_uikit/components/card/common_card.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

class PlantListPage extends LayoutWidget {
  const PlantListPage({Key? key}) : super(key: key);

  @override
  String breakTabTitle(BuildContext context) {
    return 'Plant Management';
  }

  @override
  Widget contentDesktopWidget(BuildContext context) {
    return bodyWidget(context, null, null);
  }

  @override
  Widget bodyWidget(BuildContext context, dynamic viewModel, Widget? child) {
    return const _PlantListPageContent();
  }
}

class _PlantListPageContent extends StatefulWidget {
  const _PlantListPageContent({Key? key}) : super(key: key);

  @override
  State<_PlantListPageContent> createState() => _PlantListPageContentState();
}

class _PlantListPageContentState extends State<_PlantListPageContent> {
  final TextEditingController _searchController = TextEditingController();
  List<Plant> plants = [];
  List<Plant> filteredPlants = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadPlants();
    _searchController.addListener(_filterPlants);
  }

  Future<void> _loadPlants() async {
    setState(() => isLoading = true);
    try {
      final fetchedPlants = await PlantService().fetchPlants();
      setState(() {
        plants = fetchedPlants;
        filteredPlants = fetchedPlants;
      });
    } catch (e) {
      _showMessage('Failed to load plants');
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _filterPlants() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredPlants = plants.where((plant) {
        return plant.name.toLowerCase().contains(query) ||
            plant.description.toLowerCase().contains(query);
      }).toList();
    });
  }

  Future<void> _editPlant(Plant plant) async {
    final updatedPlant = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreatePlantPage(plant: plant)),
    );
    if (updatedPlant != null) _loadPlants();
  }

  Future<void> _deletePlant(String id) async {
    try {
      await PlantService().deletePlant(id);
      _loadPlants();
    } catch (e) {
      _showMessage('Failed to delete plant');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search plants...',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.search),
            ),
          ),
        ),
        if (isLoading)
          CircularProgressIndicator()
        else if (filteredPlants.isEmpty)
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.local_florist, size: 80, color: Colors.blueGrey),
              SizedBox(height: 16),
              Text(
                "No Plants Available",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                "Add new plants to see them here.",
                style: TextStyle(color: Colors.grey),
              ),
            ],
          )
        else
          Expanded(
            child: ListView.builder(
              itemCount: filteredPlants.length,
              itemBuilder: (context, index) {
                final plant = filteredPlants[index];
                return CommonCard(
                  child: ListTile(
                    contentPadding: EdgeInsets.all(10),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: kIsWeb
                          ? Image.memory(
                              base64Decode(plant.image),
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            )
                          : Image.file(
                              File(plant.image),
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                    ),
                    title: Text(
                      plant.name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(plant.description),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            _editPlant(plant);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _confirmDelete(plant.id);
                          },
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PlantDetailPage(plant: plant),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        Padding(
          padding: EdgeInsets.all(16),
          child: FloatingActionButton(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreatePlantPage()),
              );
              if (result == true) {
                _loadPlants();
              }
            },
            child: Icon(Icons.add),
            tooltip: 'Add Plant',
          ),
        ),
      ],
    );
  }

  void _confirmDelete(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Plant'),
        content: Text('Are you sure you want to delete this plant?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deletePlant(id);
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
