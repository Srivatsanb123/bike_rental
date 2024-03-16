// ignore_for_file: no_leading_underscores_for_local_identifiers, library_private_types_in_public_api, file_names
import 'package:bike_rental/ProfileScreen.dart';
import 'package:bike_rental/RentScreen.dart';
import 'package:bike_rental/language_change_controller.dart';
import 'package:bike_rental/settings.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

enum Language { english, tamil, hindi }

class _MainScreenState extends State<MainScreen> {
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.ref().child('cycleData');

  late List<BicycleData> _bicycleDataList;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _bicycleDataList = []; // Initialize an empty list
    _databaseReference.onValue.listen((event) {
      if (event.snapshot.value != null) {
        final Map<dynamic, dynamic> data =
            event.snapshot.value as Map<dynamic, dynamic>; // Explicit cast
        final List<BicycleData> tempList = [];
        data.forEach((key, value) {
          tempList.add(BicycleData.fromJson(value));
        });
        setState(() {
          _bicycleDataList = tempList;
        });
      }
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _screens = [
      const HomeScreen(),
      RentScreen(bicycleDataList: _bicycleDataList),
      const ProfileScreen(),
      const SettingsPage(),
    ];

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: ClipRRect(
          borderRadius:
              const BorderRadius.vertical(bottom: Radius.circular(20)),
          child: Container(
            width: double.infinity,
            color: Colors.green,
            child: AppBar(
              title: Text(
                AppLocalizations.of(context)!.title,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                Consumer<LanguageChangeController>(
                  builder: (context, provider, child) {
                    return PopupMenuButton(
                      onSelected: (Language item) {
                        if (Language.english.name == item.name) {
                          provider.changeLanguage(const Locale('en'));
                        } else if (Language.tamil.name == item.name) {
                          provider.changeLanguage(const Locale('ta'));
                        } else {
                          provider.changeLanguage(const Locale('hi'));
                        }
                      },
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<Language>>[
                        const PopupMenuItem(
                            value: Language.english, child: Text('English')),
                        const PopupMenuItem(
                            value: Language.tamil, child: Text('Tamil')),
                        const PopupMenuItem(
                            value: Language.hindi, child: Text('Hindi')),
                      ],
                    );
                  },
                )
              ],
              centerTitle: true,
              backgroundColor: Colors.transparent,
              elevation: 10,
            ),
          ),
        ),
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_online),
            label: 'Rent',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Welcome to Home Page!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
