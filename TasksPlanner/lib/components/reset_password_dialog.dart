import 'package:TasksPlanner/components/popup_alert.dart';
import 'package:TasksPlanner/utilities/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

final TextEditingController textController = TextEditingController();

enum STATES { success, failure }

Future<dynamic> resetPasswordDialog(BuildContext context) async {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final Duration _snackbarDuration = Duration(seconds: 2);

  void showTopSnackBar(context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        dismissDirection: DismissDirection.up,
        duration: _snackbarDuration,
        margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height - 125,
            left: 10,
            right: 10),
        behavior: SnackBarBehavior.floating,
        content: Text(message),
      ),
    );
  }

  Future<void> sendResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      Navigator.of(context).pop();
      await Future.delayed(Duration(milliseconds: 450));
      showTopSnackBar(context, "Password reset email sent!");
    } catch (e) {
      Navigator.of(context).pop();
      await Future.delayed(Duration(milliseconds: 450));
      showTopSnackBar(context, "Invalid email. Try again.");
    }
  }

  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter your email'),
          content: TextField(
              autofocus: true,
              textAlign: TextAlign.center,
              decoration: kInputDecoration(context, ""),
              controller: _emailController,
              onEditingComplete: () {
                sendResetEmail(_emailController.text);
              }),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('CANCEL'),
            ),
            TextButton(
              onPressed: () async {
                sendResetEmail(_emailController.text);
              },
              child: Text('CONFIRM'),
            ),
          ],
        );
      });
}
