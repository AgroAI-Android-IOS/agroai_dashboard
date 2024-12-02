import 'package:flareline/pages/Plants/Model/plantModel.dart';
import 'package:flutter/material.dart';

class PlantDetailPage extends StatelessWidget {
  final Plant plant;

  PlantDetailPage({required this.plant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(plant.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(plant.image),
            const SizedBox(height: 20),
            Text(plant.name, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(plant.description),
          ],
        ),
      ),
    );
  }
}
