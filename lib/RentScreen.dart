// ignore_for_file: file_names

import 'package:bike_rental/ValidateAadhar.dart';
import 'package:flutter/material.dart';

List<BicycleData> bicycleList = [];

class BicycleData {
  final String type;
  final String count;
  final String status;

  BicycleData({
    required this.type,
    required this.count,
    required this.status,
  });

  factory BicycleData.fromJson(Map<dynamic, dynamic> json) {
    return BicycleData(
      type: json['type'] ?? '',
      count: json['count'] ?? '',
      status: json['status'] ?? '',
    );
  }
}

class RentScreen extends StatelessWidget {
  final List<BicycleData> bicycleDataList;

  const RentScreen({Key? key, required this.bicycleDataList}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: bicycleDataList.length,
          itemBuilder: (context, index) {
            final bicycleData = bicycleDataList[index];
            return Card(
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                leading: const Icon(Icons.directions_bike),
                title: Text(
                  'Bicycle Type: ${bicycleData.type}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4.0),
                    Text('Available Count: ${bicycleData.count}'),
                    const SizedBox(height: 4.0),
                    Text('Status: ${bicycleData.status}'),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => VerifyPage()),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
