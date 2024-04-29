import 'package:TasksPlanner/screens/home_page.dart';
import 'package:TasksPlanner/screens/test_screen%20copy.dart';
import 'package:TasksPlanner/screens/test_screen.dart';
import 'package:TasksPlanner/screens/welcome_screen.dart';
import 'package:TasksPlanner/utilities/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'navigation/navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: kThemeDataDark,
      home: StreamBuilder<User?>(
        stream: _auth.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.data == null) {
              return HomePage(); // No user logged in
            } else {
              return HomePage(); // User is logged in
            }
          }
          return Scaffold(
            body: Center(
              child:
                  CircularProgressIndicator(), // Loading indicator while waiting
            ),
          );
        },
      ),
      routes: routes,
    );
  }
}
