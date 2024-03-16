import 'package:flutter/material.dart';

class BicycleData {
  final String bicycleId;
  final String location;
  final String status;

  BicycleData({
    required this.bicycleId,
    required this.location,
    required this.status,
  });

  factory BicycleData.fromJson(Map<dynamic, dynamic> json) {
    return BicycleData(
      bicycleId: json['bicycleId'] ?? '',
      location: json['location'] ?? '',
      status: json['status'] ?? '',
    );
  }
}

class RentScreen extends StatelessWidget {
  final List<BicycleData> bicycleDataList;

  const RentScreen({Key? key, required this.bicycleDataList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: bicycleDataList.length,
      itemBuilder: (context, index) {
        final bicycleData = bicycleDataList[index];
        return ListTile(
          title: Text('Bicycle ID: ${bicycleData.bicycleId}'),
          subtitle: Text(
              'Location: ${bicycleData.location}\nStatus: ${bicycleData.status}'),
          leading: Icon(Icons.directions_bike),
        );
      },
    );
  }
}
