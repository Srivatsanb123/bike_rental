// ignore_for_file: avoid_print, prefer_const_constructors
import 'package:bike_rental/login/login_signup.dart';
import 'package:bike_rental/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int colorIndex = 0;
  late List<Color> themeColors;

  void signUserOut() async {
    await FirebaseAuth.instance.signOut();
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginSignupScreen()),
    );
    print("Signed-out successfully.");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text('Account'),
              subtitle: const Text('Manage your account settings'),
              leading: const Icon(Icons.account_circle),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfilePage(),
                  ),
                );
              },
            ),
            ListTile(
              title: Text('Notifications'),
              subtitle: const Text('Configure app notifications'),
              leading: const Icon(Icons.notifications),
            ),
            ListTile(
              title: Text('Languages'),
              subtitle: const Text('Configure app languages'),
              leading: const Icon(Icons.language),
              /*trailing: DropdownButton(
                value: _currentLocale, // Set the initially selected option
                items: const [
                  DropdownMenuItem(value: "en", child: Text("English")),
                  DropdownMenuItem(value: "ta", child: Text("தமிழ்")),
                  DropdownMenuItem(value: "hi", child: Text("हिंदी"))
                ],
                onChanged: (String? value) {
                  _setLocale(value);
                },
              ),*/
            ),
            ListTile(
              title: Text("Sign Out"),
              leading: const Icon(Icons.logout),
              onTap: signUserOut,
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }
}
