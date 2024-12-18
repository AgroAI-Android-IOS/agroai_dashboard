import 'package:flareline/pages/Plants/View/PlantDetailPage.dart';
import 'package:flutter/material.dart';
import 'package:flareline/pages/Plants/View/CreatePlantPage.dart';
import 'package:flareline/services/plantService.dart';
import 'package:flareline/pages/Plants/Model/plantModel.dart';
import 'package:flareline_uikit/components/card/common_card.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

class PlantListPage extends StatefulWidget {
  @override
  _PlantListPageState createState() => _PlantListPageState();
}

class _PlantListPageState extends State<PlantListPage> {
  List<Plant> plants = [];
  List<Plant> filteredPlants = [];
  bool isLoading = false;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadPlants();
    _searchController.addListener(_onSearchChanged);
  }

  Future<void> loadPlants() async {
    setState(() {
      isLoading = true;
    });

    try {
      List<Plant> fetchedPlants = await PlantService().fetchPlants();
      setState(() {
        plants = fetchedPlants;
        filteredPlants = fetchedPlants;
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to load plants')));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _onSearchChanged() {
    String query = _searchController.text.toLowerCase();
    List<Plant> results = plants.where((plant) {
      return plant.name.toLowerCase().contains(query) ||
          plant.description.toLowerCase().contains(query);
    }).toList();

    setState(() {
      filteredPlants = results;
    });
  }

  Future<void> updatePlant(Plant plant) async {
    final updatedPlant = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreatePlantPage(plant: plant),
      ),
    );
    if (updatedPlant != null) {
      loadPlants();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Plants'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreatePlantPage()),
              );
              if (result == true) {
                loadPlants();
              }
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Padding(
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
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Plant App',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('Plants'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => PlantListPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : filteredPlants.isEmpty
              ? Center(
                  child: Text(
                      'No plants found. Try searching or adding some plants!'))
              : ListView.builder(
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
                                updatePlant(plant);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Delete Plant'),
                                      content: Text(
                                          'Are you sure you want to delete this plant?'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            await PlantService()
                                                .deletePlant(plant.id);
                                            loadPlants();
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('Delete'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PlantDetailPage(plant: plant),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
