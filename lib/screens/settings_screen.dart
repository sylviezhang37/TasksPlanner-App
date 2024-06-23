import 'package:TasksPlanner/components/popup_alert.dart';
import 'package:flutter/material.dart';
import '../screens/welcome_screen.dart';
import '../models/firestore_service.dart';
import '../utilities/constants.dart';

class SettingsScreen extends StatelessWidget {
  static const String id = 'settings_screen';

  @override
  Widget build(BuildContext context) {
    void deleteAccount() {
      ListService().deleteUserAccount();
      Navigator.pushReplacementNamed(context, WelcomeScreen.id);
    }

    void deleteAccountOnPress() => popUpAlert(context, true, "Are you sure?",
            "This action will permanently erase all your account information and data.\n Click 'OK' to confirm deletion, or 'CANCEL' to cancel the action.",
            () {
          deleteAccount();
        });

    void signOutOnPress() {
      ListService().signOut();
      Navigator.pushReplacementNamed(context, WelcomeScreen.id);
    }

    return Scaffold(
      appBar: AppBar(),
      // backgroundColor: Theme.of(context).colorScheme.,
      body: SafeArea(
        child: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text(
                  'Need Help?',
                  style: kHomePageHeaderTextStyle,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.email),
                    Text(
                      ' oatsmoothie.apps@gmail.com',
                      style: kBodyTextStyleDark,
                    ),
                  ],
                ),
                kDottedLine,
                Image.asset('assets/round-nice-day.png',
                    width: MediaQuery.of(context).size.width * 0.55),
                const Text(
                  'Settings',
                  style: kHomePageHeaderTextStyle,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.15,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                          style: kElevatedButtonStyle,
                          onPressed: signOutOnPress,
                          child: const Text(
                            'Sign Out',
                            style: kBodyTextStyleDark,
                          )),
                      TextButton(
                          onPressed: deleteAccountOnPress,
                          child: Text(
                            'Delete My Account',
                            style: kHintTextStyleMini,
                          )),
                    ],
                  ),
                ),
                Text(
                  '@oatsmoothie 2024',
                  style: kHintTextStyleDark,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
