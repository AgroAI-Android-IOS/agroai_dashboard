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
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadPlants();
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
          : plants.isEmpty
              ? Center(child: Text('No plants available. Add some plants!'))
              : ListView.builder(
                  itemCount: plants.length,
                  itemBuilder: (context, index) {
                    final plant = plants[index];
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
                      trailing: IconButton(
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
                                    onPressed: () {
                                      PlantService().deletePlant(plant.id);  
                                      loadPlants();
                                       // Delete the plant
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