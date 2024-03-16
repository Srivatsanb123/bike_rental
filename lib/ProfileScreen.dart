import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
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
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Username:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(username),
            SizedBox(height: 20.0),
            Text(
              'Email:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(email),
            SizedBox(height: 20.0),
            Text(
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
