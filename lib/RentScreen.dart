// ignore_for_file: library_private_types_in_public_api, file_names
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RentScreen extends StatefulWidget {
  final List<BicycleData> bicycleDataList;

  const RentScreen({Key? key, List<BicycleData>? bicycleDataList})
      : bicycleDataList = bicycleDataList ?? const [],
        super(key: key);

  static const List<BicycleData> sampleBicycleData = [
    // E-Cycles
    BicycleData(
      name: 'Hero Lectro F2i',
      location: 'T. Nagar, Chennai',
      type: 'ecycle',
    ),
    BicycleData(
      name: 'EMotorad EMX',
      location: 'Adyar, Chennai',
      type: 'ecycle',
    ),
    BicycleData(
      name: 'Sehgal E-Bike Pro',
      location: 'Besant Nagar, Chennai',
      type: 'ecycle',
    ),
    BicycleData(
      name: 'Geared E-Cycle',
      location: 'Coimbatore Town',
      type: 'ecycle',
    ),
    BicycleData(
      name: 'Hero Lectro C8i',
      location: 'Kodaikanal Hill Station',
      type: 'ecycle',
    ),

    // Mountain Bikes
    BicycleData(
      name: 'Trek X-Caliber',
      location: 'Ooty Hill Station',
      type: 'mtb',
    ),
    BicycleData(
      name: 'Hercules Roadeo A300',
      location: 'Yelagiri Hills',
      type: 'mtb',
    ),
    BicycleData(
      name: 'Firefox Cyclone',
      location: 'Valparai',
      type: 'mtb',
    ),
    BicycleData(
      name: 'Polygon Xtrada 7',
      location: 'Kodaikanal Town Center',
      type: 'mtb',
    ),
    BicycleData(
      name: 'Giant Talon 3',
      location: 'Coonoor',
      type: 'mtb',
    ),
    BicycleData(
      name: 'Scott Aspect 960',
      location: 'Yercaud Hills',
      type: 'mtb',
    ),

    // Normal Bikes
    BicycleData(
      name: 'Decathlon Riverside 120',
      location: 'Marina Beach, Chennai',
      type: 'normal',
    ),
    BicycleData(
      name: 'Hero Sundancer',
      location: 'Mahabalipuram, ECR',
      type: 'normal',
    ),
    BicycleData(
      name: 'BSA Ladybird',
      location: 'Mylapore, Chennai',
      type: 'normal',
    ),
    BicycleData(
      name: 'Hero Sprint',
      location: 'Madurai Temple Area',
      type: 'normal',
    ),
    BicycleData(
      name: 'Atlas Street King',
      location: 'Pondicherry Beach Road',
      type: 'normal',
    ),
    BicycleData(
      name: 'Hercules MTB Dynor',
      location: 'Thanjavur Town',
      type: 'normal',
    ),
    BicycleData(
      name: 'Firefox CityScape',
      location: 'Trichy Central',
      type: 'normal',
    ),
    BicycleData(
      name: 'BSA Photon Ex',
      location: 'Salem City',
      type: 'normal',
    ),
  ];

  @override
  _RentScreenState createState() => _RentScreenState();
}

class _RentScreenState extends State<RentScreen>
    with SingleTickerProviderStateMixin {
  late List<BicycleData> _eCycleList;
  late List<BicycleData> _mtbList;
  late List<BicycleData> _normalList;
  late List<BicycleData> _filteredList;
  bool _isLoading = true;

  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(hours: 1));

  @override
  void initState() {
    super.initState();

    // If the bicycleDataList is empty, use sample data
    final dataList = widget.bicycleDataList.isEmpty
        ? RentScreen.sampleBicycleData
        : widget.bicycleDataList;

    // Simulate a loading delay to show UI transition
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _eCycleList =
              dataList.where((data) => data.type == "ecycle").toList();
          _mtbList = dataList.where((data) => data.type == "mtb").toList();
          _normalList =
              dataList.where((data) => data.type == "normal").toList();
          _filteredList = dataList;
          _isLoading = false;
        });
      }
    });

    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(_handleTabSelection);

    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
        _filterBicycles();
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _filterBicycles();
      });
    }
  }

  void _filterBicycles() {
    switch (_tabController.index) {
      case 0:
        _filteredList = widget.bicycleDataList;
        break;
      case 1:
        _filteredList = _eCycleList;
        break;
      case 2:
        _filteredList = _mtbList;
        break;
      case 3:
        _filteredList = _normalList;
        break;
    }

    if (_searchQuery.isNotEmpty) {
      _filteredList = _filteredList.where((bicycle) {
        return bicycle.name.toLowerCase().contains(_searchQuery) ||
            bicycle.location.toLowerCase().contains(_searchQuery);
      }).toList();
    }
  }

  void _onCycleSelected(BicycleData cycle) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(builder: (context, setModalState) {
          return Container(
            padding: const EdgeInsets.all(20),
            height: MediaQuery.of(context).size.height * 0.7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      cycle.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: _getColorForType(cycle.type),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: Icon(
                      _getIconForType(cycle.type),
                      size: 100,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _buildInfoRow(
                    Icons.category, 'Type', _getReadableType(cycle.type)),
                _buildInfoRow(Icons.location_on, 'Location', cycle.location),
                _buildInfoRow(Icons.attach_money, 'Hourly Rate',
                    _getPriceForType(cycle.type)),
                const SizedBox(height: 20),
                const Text(
                  'Select Rental Period',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _buildDateTimeSelector(
                        'Start',
                        _startDate,
                        (newDate) {
                          setModalState(() {
                            _startDate = newDate;
                            // Ensure end date is after start date
                            if (_endDate.isBefore(_startDate)) {
                              _endDate =
                                  _startDate.add(const Duration(hours: 1));
                            }
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildDateTimeSelector(
                        'End',
                        _endDate,
                        (newDate) {
                          setModalState(() {
                            _endDate = newDate;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  'Total: \$${_calculateTotalPrice(cycle.type, _startDate, _endDate)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      _confirmRental(cycle);
                    },
                    child:
                        const Text('Rent Now', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  Widget _buildDateTimeSelector(
      String label, DateTime initialDate, Function(DateTime) onDateSelected) {
    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: initialDate,
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 30)),
        );

        if (date != null) {
          final time = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.fromDateTime(initialDate),
          );

          if (time != null) {
            final newDateTime = DateTime(
              date.year,
              date.month,
              date.day,
              time.hour,
              time.minute,
            );
            onDateSelected(newDateTime);
          }
        }
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              DateFormat('MMM dd, yyyy - h:mm a').format(initialDate),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  String _calculateTotalPrice(String type, DateTime start, DateTime end) {
    final hourlyRate = double.parse(_getPriceForType(type).replaceAll('₹', ''));
    final hours = end.difference(start).inMinutes / 60.0;
    return (hourlyRate * hours).toStringAsFixed(2);
  }

  void _confirmRental(BicycleData cycle) {
    final hours = _endDate.difference(_startDate).inMinutes / 60.0;
    final formattedHours = hours.toStringAsFixed(1);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Booking Confirmed'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('You have rented ${cycle.name} for $formattedHours hours.'),
              const SizedBox(height: 10),
              Text(
                  'Pick-up: ${DateFormat('MMM dd, yyyy - h:mm a').format(_startDate)}'),
              Text(
                  'Return: ${DateFormat('MMM dd, yyyy - h:mm a').format(_endDate)}'),
              const SizedBox(height: 10),
              Text('Location: ${cycle.location}'),
              const SizedBox(height: 10),
              Text(
                  'Total: ₹${_calculateTotalPrice(cycle.type, _startDate, _endDate)}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey),
          const SizedBox(width: 10),
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value),
        ],
      ),
    );
  }

  String _getReadableType(String type) {
    switch (type) {
      case 'ecycle':
        return 'Electric Bicycle';
      case 'mtb':
        return 'Mountain Bike';
      case 'normal':
        return 'Standard Bicycle';
      default:
        return 'Unknown';
    }
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'ecycle':
        return Icons.electric_bike;
      case 'mtb':
        return Icons.directions_bike;
      case 'normal':
        return Icons.pedal_bike;
      default:
        return Icons.bike_scooter;
    }
  }

  Color _getColorForType(String type) {
    switch (type) {
      case 'ecycle':
        return Colors.blue.shade200;
      case 'mtb':
        return Colors.green.shade200;
      case 'normal':
        return Colors.orange.shade200;
      default:
        return Colors.grey;
    }
  }

  String _getPriceForType(String type) {
    switch (type) {
      case 'ecycle':
        return '₹150.00';
      case 'mtb':
        return '₹100.00';
      case 'normal':
        return '₹50.00';
      default:
        return '₹0.00';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rent a Bicycle'),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'E-Cycles'),
            Tab(text: 'Mountain Bikes'),
            Tab(text: 'Standard Bikes'),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.grey[50],
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Find Your Perfect Ride',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search by name or location',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : _filteredList.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.no_transfer,
                              size: 70,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No bicycles match your search criteria',
                              style: TextStyle(
                                  fontSize: 16, color: Colors.grey[600]),
                            ),
                            const SizedBox(height: 8),
                            TextButton(
                              onPressed: () {
                                _searchController.clear();
                                _tabController.animateTo(0);
                              },
                              child: const Text('Clear filters'),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: () async {
                          // Simulate refresh
                          setState(() {
                            _isLoading = true;
                          });

                          await Future.delayed(const Duration(seconds: 1));

                          setState(() {
                            _isLoading = false;
                          });
                        },
                        child: GridView.builder(
                          padding: const EdgeInsets.all(16.0),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.75,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                          itemCount: _filteredList.length,
                          itemBuilder: (context, index) {
                            final cycle = _filteredList[index];
                            return _buildBicycleCard(cycle);
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildBicycleCard(BicycleData bicycle) {
    return GestureDetector(
      onTap: () => _onCycleSelected(bicycle),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: _getColorForType(bicycle.type),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(15)),
              ),
              child: Center(
                child: Icon(
                  _getIconForType(bicycle.type),
                  size: 70,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bicycle.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          bicycle.location,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _getPriceForType(bicycle.type),
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _getReadableType(bicycle.type),
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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
  final String type;

  const BicycleData({
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
