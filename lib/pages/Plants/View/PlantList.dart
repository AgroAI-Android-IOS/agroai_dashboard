import 'package:flareline/pages/Plants/View/CreatePlantPage.dart';
import 'package:flutter/material.dart';
import 'package:flareline/services/plantService.dart'; // Import the PlantService
import 'package:flareline/pages/Plants/View/PlantDetailPage.dart'; // Import the PlantDetailPage
import 'package:flareline/pages/Plants/Model/plantModel.dart';
import 'package:http/http.dart';

class PlantListPage extends StatefulWidget {
  @override
  _PlantListPageState createState() => _PlantListPageState();
}

class _PlantListPageState extends State<PlantListPage> {
  List<Plant> plants = [];
  List<Plant> filteredPlants = []; // List to store filtered plants
  bool isLoading = false;
  TextEditingController _searchController = TextEditingController(); // Controller for search bar

  @override
  void initState() {
    super.initState();
    loadPlants();
    _searchController.addListener(_onSearchChanged); // Listen for search query changes
  }

  // Load plants from the API
  Future<void> loadPlants() async {
    setState(() {
      isLoading = true;
    });

    try {
      List<Plant> fetchedPlants = await PlantService().fetchPlants();
      setState(() {
        plants = fetchedPlants;
        filteredPlants = fetchedPlants; // Initially, show all plants
      });
    } catch (e) {
      // Handle the error here
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to load plants')));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Handle search query change
  void _onSearchChanged() {
    String query = _searchController.text.toLowerCase();
    List<Plant> results = plants.where((plant) {
      return plant.name.toLowerCase().contains(query) ||
             plant.description.toLowerCase().contains(query); // Filter by name or description
    }).toList();

    setState(() {
      filteredPlants = results; // Update filtered plant list
    });
  }

  // Update a plant's details
  Future<void> updatePlant(Plant plant) async {
    final updatedPlant = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreatePlantPage(plant: plant), // Pass the plant to the update page
      ),
    );
    if (updatedPlant != null) {
      // If the plant is updated, reload the plants list
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
            onPressed: () {
              // Navigate to CreatePlantPage
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreatePlantPage()),
              ).then((_) => loadPlants());  // Reload plants after adding a new one
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
                Navigator.pop(context); // Close the drawer
                // Navigate to the same PlantListPage
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => PlantListPage()),
                );
              },
            ),
            // Add more ListTiles here for other pages if needed
          ],
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : filteredPlants.isEmpty
              ? Center(child: Text('No plants found. Try searching or adding some plants!'))
              : ListView.builder(
                  itemCount: filteredPlants.length,
                  itemBuilder: (context, index) {
                    final plant = filteredPlants[index];
                    return ListTile(
                      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      leading: Image.network(
                        plant.image,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      title: Text(plant.name),
                      subtitle: Text(plant.description),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Update Button
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              // Navigate to Update Plant Page
                              updatePlant(plant);
                            },
                          ),
                          // Delete Button
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              // Confirm before deleting
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Delete Plant'),
                                    content: Text('Are you sure you want to delete this plant?'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          await PlantService().deletePlant(plant.id);
                                          loadPlants();  // Refresh the plant list after deletion
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
                            builder: (context) => PlantDetailPage(plant: plant),
                          ),
                        );
                      },
                    );
                  },
                ),
    );
  }
}
