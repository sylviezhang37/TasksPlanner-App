import 'package:TasksPlanner/components/popup_alert.dart';
import 'package:flutter/material.dart';
import '../screens/welcome_screen.dart';
import '../models/list_service.dart';
import '../utilities/constants.dart';

class SettingsScreen extends StatelessWidget {
  static const String id = 'settings_screen';

  @override
  Widget build(BuildContext context) {
    void deleteAccount() {
      ListService().deleteUserAccount();
      Navigator.pushReplacementNamed(context, WelcomeScreen.id);
    }

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.15),
          Center(
              child: ElevatedButton(
                  child: Text(
                    'Sign Out',
                    style: kSubtitleTextStyle,
                  ),
                  onPressed: () {
                    ListService().signOut();
                    Navigator.pushReplacementNamed(context, WelcomeScreen.id);
                  })),
          Center(
              child: ElevatedButton(
                  child: Text(
                    'Delete My Account',
                    style: kSubtitleTextStyle,
                  ),
                  onPressed: () {
                    popUpAlert(context, true, "Are you sure?",
                        "This action will permanently erase all your account information and data.\n Click 'OK' to confirm deletion, or 'CANCEL' to cancel the action.",
                        () {
                      deleteAccount();
                    });
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
