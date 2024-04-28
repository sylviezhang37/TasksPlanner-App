import 'package:flutter/material.dart';
import '../screens/welcome_screen.dart';
import '../models/list_service.dart';
import '../utilities/constants.dart';

class SettingsScreen extends StatelessWidget {
  static const String id = 'settings_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.15),
          Center(
              child: ElevatedButton(
                  child: Text(
                    'Sign out',
                    style: kSubtitleTextStyle,
                  ),
                  onPressed: () {
                    ListService().signOut();
                    Navigator.pushReplacementNamed(context, WelcomeScreen.id);
                  })),
          const Center(
              child: Text(
            '@oatsmoothie 2024',
            style: kSubtitleTextStyle,
          )),
        ],
      ),
    );
  }
}
