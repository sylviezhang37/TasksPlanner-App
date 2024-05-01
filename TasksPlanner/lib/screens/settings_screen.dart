import 'package:TasksPlanner/components/popup_alert.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../screens/welcome_screen.dart';
import '../models/list_service.dart';
import '../utilities/constants.dart';

class SettingsScreen extends StatelessWidget {
  static const String id = 'settings_screen';
  String _url = 'https://sites.google.com/view/oatsmoothie';

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
                Image.asset('assets/clicking-post.png',
                    width: MediaQuery.of(context).size.width * 0.5),
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
                      ElevatedButton(
                          style: kElevatedButtonStyle,
                          onPressed: deleteAccountOnPress,
                          child: const Text(
                            'Delete My Account',
                            style: kBodyTextStyleDark,
                          )),
                    ],
                  ),
                ),
                Text(
                  '@oatsmoothie 2024',
                  style: kHintTextStyle,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
