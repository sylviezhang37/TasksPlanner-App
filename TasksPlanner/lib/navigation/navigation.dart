import 'package:flutter/material.dart';
import '../screens/settings_screen.dart';
import '../screens/home_page.dart';
import '../screens/login_screen.dart';
import '../screens/registration_screen.dart';
import '../screens/welcome_screen.dart';

Map<String, Widget Function(BuildContext)> routes = <String, WidgetBuilder>{
  WelcomeScreen.id: (context) => WelcomeScreen(),
  Registration.id: (context) => Registration(),
  LoginScreen.id: (context) => LoginScreen(),
  HomePage.id: (context) => HomePage(),
  SettingsScreen.id: (context) => SettingsScreen()
};
