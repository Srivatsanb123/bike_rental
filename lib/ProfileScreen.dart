// ignore_for_file: library_private_types_in_public_api, file_names
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String username = 'John Doe';
  String email = 'johndoe@example.com';
  String phoneNumber = '+1 234 567 890';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Username:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(username),
            const SizedBox(height: 20.0),
            const Text(
              'Email:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(email),
            const SizedBox(height: 20.0),
            const Text(
              'Phone Number:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(phoneNumber),
          ],
        ),
      ),
    );
  }
}
