import 'package:bike_rental/firebase_options.dart';
import 'package:bike_rental/language_change_controller.dart';
import 'package:bike_rental/login/auth_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LanguageChangeController())
      ],
      child: Consumer<LanguageChangeController>(
          builder: (context, provider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'TrackED',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          locale: provider.appLocale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en'), Locale('ta'), Locale('hi')],
          home: FutureBuilder(
            future: Future.wait([
              Firebase.initializeApp(),
              SharedPreferences.getInstance(),
            ]),
            builder:
                (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                // Firebase and SharedPreferences initialization completed
                Firebase.initializeApp(); // Ensure Firebase is initialized
                // ignore: unused_local_variable
                SharedPreferences prefs =
                    snapshot.data![1]; // Access SharedPreferences instance
                return const AuthPage();
              } else if (snapshot.hasError) {
                // Handle errors
                if (kDebugMode) {
                  print("Error during initialization: ${snapshot.error}");
                }
                return const Text("Something went wrong!");
              } else {
                return const Text("Something went wrong!");
              }
            },
          ),
        );
      }),
    );
  }
}
