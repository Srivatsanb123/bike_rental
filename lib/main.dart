import 'package:bike_rental/firebase_options.dart';
import 'package:bike_rental/login/auth_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TrackED',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FutureBuilder(
        future: Future.wait([
          Firebase.initializeApp(),
          SharedPreferences.getInstance(),
        ]),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            SharedPreferences prefs = snapshot.data![1];
            return const AuthPage();
          } else if (snapshot.hasError) {
            if (kDebugMode) {
              print("Error during initialization: ${snapshot.error}");
            }
            return const Text("Something went wrong!");
          } else {
            return const CircularProgressIndicator(); // Better than plain text
          }
        },
      ),
    );
  }
}
