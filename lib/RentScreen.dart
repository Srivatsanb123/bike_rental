// ignore_for_file: library_private_types_in_public_api, file_names
import 'package:bike_rental/payment.dart';
import 'package:flutter/material.dart';

class RentScreen extends StatefulWidget {
  final List<BicycleData> bicycleDataList;

  const RentScreen({Key? key, required this.bicycleDataList}) : super(key: key);

  @override
  _RentScreenState createState() => _RentScreenState();
}

class _RentScreenState extends State<RentScreen> {
  late List<BicycleData> _eCycleList;
  late List<BicycleData> _mtbList;
  late List<BicycleData> _normalList;

  @override
  void initState() {
    super.initState();
    _eCycleList =
        widget.bicycleDataList.where((data) => data.type == "ecycle").toList();
    _mtbList =
        widget.bicycleDataList.where((data) => data.type == "mtb").toList();
    _normalList =
        widget.bicycleDataList.where((data) => data.type == "normal").toList();
  }

  void _onCycleSelected(BicycleData selectedCycle) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => PaymentPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rent a Bicycle'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCycleList('E-Cycles', _eCycleList),
            _buildCycleList('MTB', _mtbList),
            _buildCycleList('Normal Bicycles', _normalList),
          ],
        ),
      ),
    );
  }

  Widget _buildCycleList(String title, List<BicycleData> cycleList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: cycleList.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(cycleList[index].name),
              subtitle: Text('Location: ${cycleList[index].location}'),
              onTap: () {
                _onCycleSelected(cycleList[index]);
              },
            );
          },
        ),
      ],
    );
  }
}

enum BicycleType {
  eCycle,
  mtb,
  normal,
}

class BicycleData {
  final String name;
  final String location;
  late final String type;

  BicycleData({
    required this.name,
    required this.location,
    required this.type,
  });

  factory BicycleData.fromJson(Map<String, dynamic> json) {
    return BicycleData(
      name: json['name'],
      location: json['location'],
      type: json['type'],
    );
  }
}
