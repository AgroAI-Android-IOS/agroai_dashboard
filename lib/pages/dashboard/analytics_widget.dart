import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:responsive_builder/responsive_builder.dart';
import 'package:flareline/pages/Plants/Model/plantModel.dart';
import 'package:provider/provider.dart';
import 'package:flareline/pages/Plants/Providers/plant_provider.dart';

class AnalyticsWidget extends StatelessWidget {
  const AnalyticsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return _analytics(context);
  }

  Widget _analytics(BuildContext context) {
    return ScreenTypeLayout.builder(
      desktop: (BuildContext context) => _analyticsWeb(context),
      mobile: (BuildContext context) => _analyticsMobile(context),
      tablet: (BuildContext context) => _analyticsMobile(context),
    );
  }

  Widget _analyticsWeb(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _buildPlantTypeChart(context)),
        Expanded(child: _buildPlantAddedChart(context)),
      ],
    );
  }

  Widget _analyticsMobile(BuildContext context) {
    return Column(
      children: [
        _buildPlantTypeChart(context),
        _buildPlantAddedChart(context),
      ],
    );
  }

  Widget _buildPlantTypeChart(BuildContext context) {
    final plantProvider = Provider.of<PlantProvider>(context);
    final plantTypeData = _getPlantTypeData(plantProvider.plants);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Plant Distribution by Type', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 200, child: charts.PieChart(plantTypeData)),
          ],
        ),
      ),
    );
  }

  Widget _buildPlantAddedChart(BuildContext context) {
    final plantProvider = Provider.of<PlantProvider>(context);
    final plantAddedData = _getPlantAddedData(plantProvider.plants);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Plants Added Over Time', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 200, child: charts.TimeSeriesChart(plantAddedData)),
          ],
        ),
      ),
    );
  }

  List<charts.Series<PlantTypeData, String>> _getPlantTypeData(List<Plant> plants) {
    final data = <String, int>{};

    for (var plant in plants) {
      data[plant.type] = (data[plant.type] ?? 0) + 1;
    }

    final chartData = data.entries.map((entry) => PlantTypeData(entry.key, entry.value)).toList();

    return [
      charts.Series<PlantTypeData, String>(
        id: 'PlantType',
        domainFn: (PlantTypeData data, _) => data.type,
        measureFn: (PlantTypeData data, _) => data.count,
        data: chartData,
        labelAccessorFn: (PlantTypeData row, _) => '${row.type}: ${row.count}',
      ),
    ];
  }

  List<charts.Series<PlantAddedData, DateTime>> _getPlantAddedData(List<Plant> plants) {
    final data = <DateTime, int>{};

    for (var plant in plants) {
      final date = DateTime(plant.addedDate.year, plant.addedDate.month, plant.addedDate.day);
      data[date] = (data[date] ?? 0) + 1;
    }

    final chartData = data.entries.map((entry) => PlantAddedData(entry.key, entry.value)).toList();

    return [
      charts.Series<PlantAddedData, DateTime>(
        id: 'PlantAdded',
        domainFn: (PlantAddedData data, _) => data.date,
        measureFn: (PlantAddedData data, _) => data.count,
        data: chartData,
      ),
    ];
  }
}

class PlantTypeData {
  final String type;
  final int count;

  PlantTypeData(this.type, this.count);
}

class PlantAddedData {
  final DateTime date;
  final int count;

  PlantAddedData(this.date, this.count);
}